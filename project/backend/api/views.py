from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny, BasePermission
from database.serializers import *
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth.models import User
from rest_framework.authentication import TokenAuthentication
from django.http import JsonResponse
from rest_framework import generics, status
from django.contrib.postgres.search import SearchVector
from database.models import *
import random

# from nltk.corpus import wordnet as wn
# import nltk
#
# nltk.download('wordnet')

# Create your views here.

# Class based view to register user
class SignUpAPIView(generics.CreateAPIView):
    permission_classes = (AllowAny,) 
    serializer_class = RegisterSerializer

# Class based view to get User details using Token Authentication
class UserDetailAPI(APIView):
  authentication_classes = (TokenAuthentication,)
  permission_classes = (IsAuthenticated,)

  def get(self, request, *args, **kwargs):
    user = User.objects.get(id=request.user.id)
    serializer = UserSerializer(user)

    return Response(serializer.data)

class ChangePasswordView(generics.UpdateAPIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    queryset = User.objects.all()
    serializer_class = ChangePasswordSerializer

    def get_object(self):
        return self.request.user

class ChangeProfileSettingsView(generics.UpdateAPIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    queryset = BasicUser.objects.all()
    serializer_class = ChangeProfileSettingsSerializer

    def get_object(self):
        return self.request.user.basicuser
      
class NodeAPIView(APIView):
  
    def get(self, request):
        id = int(request.GET.get("node_id"))
        node = Node.objects.filter(node_id=id)
        if node.count() == 0:
            return JsonResponse(
                {"message": "There is no node with this id."}, status=404
            )
        elif node.first().removed_by_admin:
            return JsonResponse(
                {"message": "The node is removed by admin."}, status=404
            )
        node = node.first()
        serializer = NodeSerializer(node)
        return Response(serializer.data)

class IsContributorAndWorkspace(BasePermission):
    def has_permission(self, request, view):
        workspace_id = request.data.get('workspace_id')
        if not request.user.is_authenticated:
            return False
        if not Contributor.objects.filter(pk=request.user.basicuser.pk).exists():
            return False
        if workspace_id is not None:
            return request.user.basicuser.contributor.workspaces.filter(workspace_id=workspace_id).exists()
        return True

class WorkspacePostAPIView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated, IsContributorAndWorkspace)

    def post(self, request):
        serializer = WorkspaceSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(
            serializer.errors, status=400
        )

def search(request):
    search = request.GET.get("query")
    search_type = request.GET.get("type")
    if search == None or search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=400)
    if search_type == None or search_type == "":
        return JsonResponse({'status': 'Type to search must be given.'}, status=400)
    if search_type != 'node' and search_type != 'author' and search_type != 'all' and search_type != 'by':
        return JsonResponse({'status': 'invalid search type.'}, status=400)
    search_elements = search.split()
    # similars = [] # TODO ADVANCED SEARCH
    # also_sees = []
    #
    # for element in search_elements:
    #     if  len(wn.synsets(element)) != 0:
    #         for el in wn.synsets(element)[0].also_sees():
    #             el = el.name()
    #             el = el[:el.find('.')]
    #             also_sees.append(el)
    #         for el in wn.synsets(element)[0].similar_tos():
    #             el = el.name()
    #             el = el[:el.find('.')]
    #             similars.append(el)
    # start search with exact search
    nodes = []

    if search_type == 'by' or search_type == 'all':
        # print(search_elements)
        for el in search_elements:
            res_name = User.objects.filter(first_name__icontains=el)
            res_surname = User.objects.filter(last_name__icontains=el)
            for e in res_name:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    cont_nodes = Contributor.objects.get(user_id=e.id).NodeContributors.all()
                    for node in cont_nodes:
                        nodes.append(node.node_id)

            for e in res_surname:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    cont_nodes = Contributor.objects.get(user_id=e.id).NodeContributors.all()
                    for node in cont_nodes:
                        nodes.append(node.node_id)


    contributors = []
    if search_type == 'node' or search_type == 'all':
        for el in search_elements:
            res = Node.objects.annotate(search=SearchVector("node_title")).filter(node_title__icontains=el)
            for e in res:
                nodes.append(e.node_id)
    if search_type == 'author' or search_type == 'all':    # TODO This method is too inefficient
        for el in search_elements:
            res_name = User.objects.filter(first_name__icontains=el)
            res_surname = User.objects.filter(last_name__icontains=el)
            for e in res_name:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    contributors.append(e.username)
            for e in res_surname:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    contributors.append(e.username)
    contributors = list(set(contributors))
    nodes = list(set(nodes))
    res_authors = []
    for cont in contributors:
        user = User.objects.get(username=cont)
        cont = Contributor.objects.get(user=user)
        res_authors.append({'name': user.first_name,
                        'surname': user.last_name, 'username': cont.user.username , 'id': cont.id})
    node_infos = []
    for node_id in nodes:
        node = Node.objects.get(node_id=node_id)
        authors = []
        for cont in node.contributors.all():
            user = User.objects.get(id=cont.user_id)
            authors.append({'name': user.first_name,
                            'surname': user.last_name, 'username': user.username, 'id': cont.id})
        node_infos.append({'id': node_id, 'title': node.node_title, 'date': node.publish_date, 'authors': authors})
    return JsonResponse({'nodes' : node_infos , 'authors' :res_authors },status=200)



def get_profile(request):
    mail = request.GET.get("mail")
    check = User.objects.filter(username=mail)
    if check.count() == 0:
        return JsonResponse({'message': "User with this mail adress does not exist."}, status=400)
    user = User.objects.get(username=mail)
    basic_user = BasicUser.objects.get(user_id=user.id)
    cont =  Contributor.objects.filter(user_id=user.id)
    nodes = []
    asked_questions = []
    answered_questions = []
    if cont.count() != 0:
        user_nodes = Node.objects.filter(contributors=cont[0].id)
        for node in user_nodes:
            nodes.append(node.node_id)
        user_answered_qs = Question.objects.filter(answerer=cont[0].id)
        for ans in user_answered_qs:
            asker_user = User.objects.get(id=ans.asker.user_id)
            answerer_user = User.objects.get(id=ans.answerer.user_id)
            answered_questions.append({'id':ans.id, 'ask_date':ans.created_at, 'node_id':ans.node.node_id, 'node_title':ans.node.node_title, 'node_date':ans.node.publish_date,
                                       'asker_id':ans.asker.id,'asker_name':asker_user.first_name,'asker_surname':asker_user.last_name,
                                       'asker_mail':asker_user.username,'answerer_name':answerer_user.first_name,'answerer_surname':answerer_user.last_name,
                                       'answerer_mail':answerer_user.username,
                                           'answerer_id':ans.answerer.id, 'question_content':ans.question_content,
                                       'answer_content':ans.answer_content,'answer_date':ans.answered_at,'is_answered':1})

    user_asked_qs = Question.objects.filter(asker=cont[0].id)
    for q in user_asked_qs:
        asker_user = User.objects.get(id=q.asker.user_id)
        if q.answerer == None:
            asked_questions.append(
                {'id': q.id, 'ask_date': q.created_at, 'node_id': q.node.node_id, 'node_title': q.node.node_title,
                 'node_date': q.node.publish_date,
                 'asker_id': q.asker.id, 'asker_name': asker_user.first_name, 'asker_surname': asker_user.last_name,
                 'asker_mail': asker_user.username,  'question_content': q.question_content, 'is_answered': 0})
            continue
        answerer_user = User.objects.get(id=q.answerer.user_id)
        asked_questions.append(
            {'id': q.id, 'ask_date': q.created_at, 'node_id': q.node.node_id, 'node_title': q.node.node_title,
             'node_date': q.node.publish_date,
             'asker_id': q.asker.id, 'asker_name': asker_user.first_name, 'asker_surname': asker_user.last_name,
             'asker_mail': asker_user.username, 'answerer_name': answerer_user.first_name,
             'answerer_surname': answerer_user.last_name,
             'answerer_mail': answerer_user.username,
             'answerer_id': q.answerer.id, 'question_content': q.question_content,
             'answer_content': q.answer_content, 'answer_date': q.answered_at, 'is_answered':1})

    node_infos = []
    for node_id in nodes:
        node = Node.objects.get(node_id=node_id)
        authors = []
        for cont in node.contributors.all():
            user = User.objects.get(id=cont.user_id)
            authors.append({'name': user.first_name, 'surname': user.last_name, 'username': user.username})
        node_infos.append({'id':node_id,'title':node.node_title,'date':node.publish_date,'authors':authors})

    return JsonResponse({'name':user.first_name,
                         'surname':user.last_name,
                         'bio':basic_user.bio,
                         'nodes': node_infos,
                         'asked_questions':asked_questions,
                         'answered_questions':answered_questions},status=200)

def get_proof_from_id(request):
    id = int(request.GET.get("proof_id"))
    proof = Proof.objects.filter(proof_id=id)
    if proof.count() == 0:
        return JsonResponse({'message':'There is no proof with this id.'},status=404)
    data = {'proof_id': proof[0].proof_id,
            'proof_title': proof[0].proof_title,
            'proof_content': proof[0].proof_content,
            'is_valid': proof[0].is_valid,
            'is_disproof': proof[0].is_disproof,
            'publish_date': proof[0].publish_date,
            }
    return JsonResponse(data, status=200)

def get_theorem_from_id(request):
    id = int(request.GET.get("theorem_id"))
    theorem = Theorem.objects.filter(theorem_id=id)
    if theorem.count() == 0:
        return JsonResponse({'message':'There is no theorem with this id.'},status=404)

    data = {'theorem_id': theorem[0].theorem_id,
            'theorem_title': theorem[0].theorem_title,
            'theorem_content': theorem[0].theorem_content,
            'publish_date': theorem[0].publish_date,
            }
    return JsonResponse(data, status=200)


def get_contributor_from_id(request):
    id = int(request.GET.get("id"))
    cont = Contributor.objects.filter(id=id)
    if cont.count() == 0:
        return JsonResponse({'message':'There is no contributor with this id.'},status=404)
    user = User.objects.get(id=cont[0].user_id)
    data = {'id': cont[0].id,
            'username': user.username,
            'name': user.first_name,
            'surname': user.last_name,
            }
    return JsonResponse(data, status=200)

def get_workspaces(request):
    id = int(request.GET.get("user_id"))
    cont = Contributor.objects.filter(id=id)
    if cont.count() == 0:
        return JsonResponse({'message':'There is no contributor with this id.'},status=404)
    cont = cont[0]
    workspace_list = []
    for workspace in cont.workspaces.all():

        workspace_list.append({'workspace_id':workspace.workspace_id,
                               'workspace_title':workspace.workspace_title,
                               'pending':False})
    pending = []
    for req in CollaborationRequest.objects.filter(receiver=cont):
        workspace = req.workspace
        request_id = req.id
        if req.status == 'P':
            pending.append({'workspace_id': workspace.workspace_id,
                                   'workspace_title': workspace.workspace_title,
                                   'pending': True,
                            'request_id':request_id})

    return JsonResponse({'workspaces':workspace_list,'pending_workspaces':pending}, status=200)

def get_workspace_from_id(request):
    id = int(request.GET.get("workspace_id"))
    workspace = Workspace.objects.filter(workspace_id=id)
    if workspace.count() == 0:
        return JsonResponse({'message':'There is no workspace with this id.'},status=404)
    workspace = workspace[0]
    entries = []
    for entry in workspace.entries.all():
        entries.append({'entry_id':entry.entry_id,
                        'entry_date':entry.entry_date,
                        'content':entry.content,
                        'entry_index':entry.entry_index,
                        'is_theorem_entry':entry.is_theorem_entry,
                        'is_final_entry':entry.is_final_entry,
                        'is_proof_entry':entry.is_proof_entry,
                        'is_editable':entry.is_editable,
                        'entry_number':entry.entry_number,})
    semantic_tags = []
    for tag in workspace.semantic_tags.all():
        semantic_tags.append({'wid':tag.wid,
                              'label':tag.label,})
    contributors = []
    for cont in Contributor.objects.filter(workspaces=workspace):
        user = User.objects.get(id=cont.user_id)
        contributors.append({"id": cont.id,
                            "first_name": user.first_name,
                            "last_name": user.last_name,
                            "username": user.username})
    pending = []
    for pend in CollaborationRequest.objects.filter(workspace=workspace):
        cont = pend.receiver
        user = User.objects.get(id=cont.user_id)
        if pend.status == 'P':
            pending.append({"id": cont.id,
                             "first_name": user.first_name,
                             "last_name": user.last_name,
                             "username": user.username})
    references = []
    for ref in workspace.references.all():
        authors = []
        for cont in ref.contributors.all():
            user = User.objects.get(id=cont.user_id)
            authors.append({"id": cont.id,
                            "first_name": user.first_name,
                            "last_name": user.last_name,
                            "username": user.username})
        references.append({'node_id':ref.node_id,
                           'node_title':ref.node_title,
                           'contributors':authors,
                           'publish_date':ref.publish_date})
    status = 'workable'
    if workspace.is_published:
        status = 'published'
    elif workspace.is_rejected:
        status = 'rejected'
    elif workspace.is_in_review:
        status = 'in_review'
    elif workspace.is_finalized:
        status = 'finalized'
    return JsonResponse({'workspace_id': workspace.workspace_id,
                         'workspace_title':workspace.workspace_title,
                         'workspace_entries': entries,
                         'status':status,
                         'num_approvals':workspace.num_approvals,
                         'contributors':contributors,
                         'pending_contributors':pending,
                        'references':references,
                         'created_at':workspace.created_at,
                         }, status=200)
@csrf_exempt
def delete_entry(request):
    entry_id = request.POST.get("entry_id")
    workspace_id = request.POST.get("workspace_id")
    if entry_id == None or entry_id == '':
        return JsonResponse({'message': 'entry_id field can not be empty'}, status=400)
    try:
        entry_id = int(entry_id)
    except:
        return JsonResponse({'message': 'entry_id field has to be a integer'}, status=400)
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id  field has to be a integer'}, status=400)
    entry = Entry.objects.filter(entry_id=entry_id)
    if entry.count() == 0:
        return JsonResponse({'message': 'There is no entry with this id.'}, status=404)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if entry[0] not in workspace.entries.all():
        return JsonResponse({'message': 'There is no entry with this id in this workspace.'}, status=404)
    workspace.entries.remove(entry[0])
    workspace.save()
    return JsonResponse({'message': 'Entry with this id has been deleted from this workspace successfully.'}, status=200)

@csrf_exempt
def edit_entry(request):
    entry_id = request.POST.get("entry_id")
    content = request.POST.get("content")
    if entry_id == None or entry_id == '':
        return JsonResponse({'message': 'entry_id field can not be empty'}, status=400)
    try:
        entry_id = int(entry_id)
    except:
        return JsonResponse({'message': 'entry_id field has to be a integer'}, status=400)
    if content == None:
        content = ''
    entry = Entry.objects.filter(entry_id=entry_id)
    if entry.count() == 0:
        return JsonResponse({'message': 'there is no entry with this id'}, status=404)
    entry = Entry.objects.get(entry_id=entry_id)
    entry.content = content
    entry.save(update_fields=["content"])
    return JsonResponse({'message': 'entry content is updated successfully'}, status=200)
@csrf_exempt
def delete_workspace(request):
    workspace_id = request.POST.get("workspace_id")
    contributor_id = request.POST.get("contributor_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    if contributor_id == None or contributor_id == '':
        return JsonResponse({'message': 'node_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
        contributor_id = int(contributor_id)
    except:
        return JsonResponse({'message': 'workspace_id and contributor_id fields have to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    contributor = Contributor.objects.filter(id=contributor_id)
    if contributor.count() == 0:
        return JsonResponse({'message': 'There is no contributor with this id.'}, status=404)
    if workspace[0] not in contributor[0].workspaces.all():
        return JsonResponse({'message': 'there is no contributor with this id in this workspace.'}, status=404)
    contributor[0].workspaces.remove(workspace[0])
    contributor[0].save()
    # if workspace[0].contributor_set.all().count() == 0:
    #     workspace[0].delete()
    return JsonResponse({'message': 'workspace deleted successfully.'}, status=200)

@csrf_exempt
def delete_contributor(request):
    contributor_id = request.POST.get("contributor_id")
    workspace_id = request.POST.get("workspace_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    if contributor_id == None or contributor_id == '':
        return JsonResponse({'message': 'node_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
        contributor_id = int(contributor_id)
    except:
        return JsonResponse({'message': 'workspace_id and contributor_id fields have to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    contributor = Contributor.objects.filter(id=contributor_id)
    if contributor.count() == 0:
        return JsonResponse({'message': 'There is no contributor with this id.'}, status=404)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    if workspace[0] not in contributor[0].workspaces.all():
        return JsonResponse({'message': 'there is no contributor with this id in this workspace.'}, status=404)
    contributor[0].workspaces.remove(workspace[0])
    contributor[0].save()
    return JsonResponse({'message': 'Contributor from workspace deleted successfully.'}, status=200)


@csrf_exempt
def delete_reference(request):
    workspace_id = request.POST.get("workspace_id")
    node_id = request.POST.get("node_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    if node_id == None or node_id == '':
        return JsonResponse({'message': 'node_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
        node_id = int(node_id)
    except:
        return JsonResponse({'message': 'workspace_id and node_id fields have to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    if workspace[0].is_finalized == True:
        return JsonResponse({'message': ' workspace already finalized'}, status=400)
    workspace = workspace[0]
    reference = workspace.references.filter(node_id = node_id)
    if reference.count() == 0:
        return JsonResponse({'message': 'There is no reference with this id in this workspace.'}, status=404)
    workspace.references.remove(reference[0])
    return JsonResponse({'message': 'reference deleted successfully.'}, status=200)


@csrf_exempt
def finalize_workspace(request):
    workspace_id = request.POST.get("workspace_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id field has to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    if workspace[0].is_finalized == True:
        return JsonResponse({'message': ' workspace already finalized'}, status=400)
    workspace = workspace[0]
    workspace.is_finalized = True
    workspace.is_in_review = False
    workspace.save()
    return JsonResponse({'message': 'workspace successfully finalized'}, status=200)

@csrf_exempt
def add_entry(request):
    workspace_id = request.POST.get("workspace_id")
    content = request.POST.get("entry_content")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id field has to be a integer'}, status=400)
    if content == None:
        content = ''
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    if workspace[0].is_finalized == True:
        return JsonResponse({'message': ' workspace already finalized'}, status=400)
    entry = Entry.objects.create(content=content,entry_index=0, entry_number=0) # TODO WILL BE PROVIDED IN THE FUTURE
    workspace[0].entries.add(entry) ##
    workspace[0].save()
    return JsonResponse({'message': 'Entry successfully added to workspace',
                         'entry_id': entry.entry_id}, status=200)
@csrf_exempt
def add_reference(request):
    workspace_id = request.POST.get("workspace_id")
    node_id = request.POST.get("node_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    if node_id == None or node_id == '':
        return JsonResponse({'message': 'node_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
        node_id = int(node_id)
    except:
        return JsonResponse({'message': 'workspace_id and node_id fields have to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace[0].is_finalized == True:
        return JsonResponse({'message': ' workspace already finalized'}, status=400)
    node = Node.objects.filter(node_id=node_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    if node.count() == 0:
        return JsonResponse({'message': 'There is no node with this id.'}, status=404)
    if node[0] in workspace[0].references.all():
        return JsonResponse({'message': 'this reference already exists in this workspace.'}, status=400)
    workspace[0].references.add(node[0])
    workspace[0].save()
    return JsonResponse({'message': 'reference added to the workspace successfully.'}, status=200)
@csrf_exempt
def create_workspace(request):
    title = request.POST.get("workspace_title")
    user_id = request.POST.get("user_id")
    if title == '' or title == None:
        return JsonResponse({'message': 'workspace_title field can not be empty'}, status=400)
    if user_id == '' or user_id == None:
        return JsonResponse({'message': 'user_id field can not be empty'}, status=400)
    try:
        creator = int(user_id)
    except:
        return JsonResponse({'message': 'user_id has to be a integer'}, status=400)
    cont = Contributor.objects.filter(id=user_id)
    if cont.count() == 0:
        return JsonResponse({'message': 'there is no contributor with this user_id'}, status=400)
    workspace = Workspace.objects.create(workspace_title=title)
    workspace.save()
    cont[0].workspaces.add(workspace)
    return JsonResponse({'message': 'Workspace with title ' + title + ' has been added successfully' ,
                         'workspace_id' : workspace.workspace_id}, status=200)
@csrf_exempt
def get_random_node_id(request):
    count = int(request.GET.get("count"))
    node_ids = Node.node_id.all()
    node_list = []
    for i in range(count):
        while node_ids[index] not in node_list:
            index = random.randint(0,len(node_ids))
        node_list.append(node_ids[index])
    return JsonResponse({'node_ids': node_list}, status=200)

@api_view(['POST'])
def send_collaboration_request(request):

    serializer = CollaborationRequestSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['PUT'])
def update_request_status(request):
    is_collab_req = True
    req = CollaborationRequest.objects.filter(pk=request.data.get('id'))
    if not req:
        is_collab_req = False
        req = ReviewRequest.objects.filter(pk=request.data.get('id'))
    if not req:
        return Response({"message": "Request not found."}, status=404)
    req = req.first()
    status = request.data.get('status')

    if status not in ["P", "A", "R"]:
        return Response({"message": "Invalid status value."}, status=400)

    if status == "A":
        if is_collab_req:
            try:
                req.receiver.workspaces.add(req.workspace)
            except Exception as e:
                return Response({"message": str(e)}, status=500)


    req.status = status
    req.save()

    serializer = RequestSerializer(req)
    return Response(serializer.data, status=200)

@api_view(['POST'])
def send_review_request(request):

    serializer = ReviewRequestSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

