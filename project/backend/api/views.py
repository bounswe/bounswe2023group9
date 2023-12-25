from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes, authentication_classes
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
from django.core.mail import *
import random, json, datetime

from backend import settings



# from nltk.corpus import wordnet as wn
# import nltk
#
# nltk.download('wordnet')

# Create your views here.

# Class to check if user is a Contributor
class IsContributor(BasePermission):
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        if not Contributor.objects.filter(pk=request.user.basicuser.pk).exists():
            return False
        return True

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

class BasicUserDetailAPI(APIView):
  authentication_classes = (TokenAuthentication,)
  permission_classes = (IsAuthenticated,)

  def get(self, request, *args, **kwargs):
    user = BasicUser.objects.get(user_id=request.user.id)
    user_type = 'basic_user'
    if  Contributor.objects.filter(user_id=request.user.id).exists():
        user_type = 'contributor'
    if  Reviewer.objects.filter(user_id=request.user.id).exists():
        user_type = 'reviewer'
    if Admin.objects.filter(user_id=request.user.id).exists():
       user_type = 'admin'

    return JsonResponse({'basic_user_id':user.id,
                         'bio':user.bio,
                         'email_notification_preference': user.email_notification_preference,
                         'show_activity_preference':user.show_activity_preference,
                         'user_type':user_type},status=200)


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
        id = request.GET.get("node_id")
        # res = BasicUserDetailAPI.as_view()(request)
        try:
            admin = Admin.objects.filter(pk=request.user.basicuser)
            is_admin = False
            if admin.exists():
                is_admin = True
        except:
            is_admin = False
        if not id:
            node_list = Node.objects.all()
            return Response(NodeSerializer(node_list[random.randint(0, len(node_list)-1)]).data)
        id = int(id)
        node = Node.objects.filter(node_id=id)
        if node.count() == 0:
            return JsonResponse(
                {"message": "There is no node with this id."}, status=404
            )
        elif node.first().removed_by_admin and not is_admin:
            return JsonResponse(
                {"message": "The node is removed by admin."}, status=404
            )
        node = node.first()
        serializer = NodeSerializer(node)
        node.increment_num_visits()
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


def send_notification(receiver,subject,content):
        receiver = receiver.split(",")
        try:
            send_mail(subject = subject, message = content,from_email = settings.EMAIL_HOST_USER,recipient_list = receiver)
        except:
            return Response({"message": "A mistake occured while sending notification."}, status=400)
        return Response({"message": "Notification sent successfully."}, status=201)

class SemanticTagAPIView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated, IsContributorAndWorkspace)

    def post(self, request):
        serializer = SemanticTagSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(
            serializer.errors, status=400
        )

def is_workspace_contributor(request):
    workspace_id = request.data.get('workspace_id')
    if not request.user.is_authenticated:
        return False
    if not Contributor.objects.filter(pk=request.user.basicuser.pk).exists():
        return False
    if workspace_id is not None:
        return request.user.basicuser.contributor.workspaces.filter(workspace_id=workspace_id).exists()
    return True

@api_view(['PUT'])
def remove_workspace_tag(request):
    workspace_id = request.data.get("workspace_id")
    tag_id = request.data.get("tag_id")

    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id  field has to be an integer'}, status=400)
    
    if tag_id == None or tag_id == '':
        return JsonResponse({'message': 'tag_id field can not be empty'}, status=400)
    try:
        tag_id = int(tag_id)
    except:
        return JsonResponse({'message': 'tag_id  field has to be an integer'}, status=400)

    if is_workspace_contributor(request):
        workspace = Workspace.objects.get(workspace_id=workspace_id)
        tag = SemanticTag.objects.filter(id=tag_id)
        if not tag.exists():
            return JsonResponse({'message': 'There is no tag with this id.'}, status=404)
        if tag[0] not in  workspace.semantic_tags.all():
            return JsonResponse({'message': 'There is no tag with this id in this workspace.'}, status=404)
        workspace.semantic_tags.remove(tag_id)
        workspace.save()
        return JsonResponse({'message': 'Tag is successfully removed from workspace.'}, status=200)
    else:
        return JsonResponse({'message': "You don't have permission to do this!"}, status=403)


@csrf_exempt
def remove_user_tag(request):
    tag_id = request.POST.get("tag_id")
    res = BasicUserDetailAPI.as_view()(request)
    try:
        user = BasicUser.objects.filter(id=request.user.basicuser.id)
    except:
        return JsonResponse({'message': "invalid credentials."}, status=403)
    if not user.exists():
        return JsonResponse({'message': "invalid credentials."}, status=403)
    if tag_id == None or tag_id == '':
        return JsonResponse({'message': 'tag_id field can not be empty'}, status=400)
    try:
        tag_id = int(tag_id)
    except:
        return JsonResponse({'message': 'tag_id  field has to be an integer'}, status=400)
    tag = SemanticTag.objects.filter(id=tag_id)
    if not tag.exists():
        return JsonResponse({'message': 'There is no tag with this id.'}, status=404)
    tag = tag[0]
    if tag not in request.user.basicuser.semantic_tags.all():
        return JsonResponse({'message': 'This user does not have this tag.'}, status=404)
    request.user.basicuser.semantic_tags.remove(tag)
    request.user.basicuser.save()
    return JsonResponse({'message': 'Tag is successfully removed from user.'}, status=200)








def search(request):
    res = BasicUserDetailAPI.as_view()(request)
    try:
        admin = Admin.objects.filter(pk=request.user.basicuser)
        is_admin = False
        if admin.exists():
            is_admin = True
    except:
        is_admin = False
    search = request.GET.get("query")
    search_type = request.GET.get("type")
    if (search == None or search == "") and search_type != 'random' and search_type != 'trending' and search_type != 'latest' and search_type != 'most_read' and search_type != 'for_you':
        return JsonResponse({'status': 'Title to search must be given.'}, status=400)
    if search_type == None or search_type == "":
        return JsonResponse({'status': 'Type to search must be given.'}, status=400)
    if search_type != 'node' and search_type != 'author' and search_type != 'all' and search_type != 'by'and search_type != 'random' and search_type != 'semantic' and search_type != 'trending' and search_type != 'latest' and search_type != 'most_read'  and search_type != 'for_you':
        return JsonResponse({'status': 'invalid search type.'}, status=400)


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

    if search_type == 'latest':
        all = Node.objects.order_by('-publish_date')[:50]
        for node in all:
            if not node.removed_by_admin or is_admin:
                nodes.append(node.node_id)

    if search_type == 'most_read':
        all = Node.objects.order_by('-num_visits')[:50]
        for node in all:
            if not node.removed_by_admin or is_admin:
                nodes.append(node.node_id)

    if search_type == 'trending':
        all = Node.objects.order_by('-publish_date')[:250]
        rate = {}
        for node in all:
            diff = datetime.datetime.now().date() - node.publish_date
            if diff == 0:
                diff = 1
            rate[node.node_id] = node.num_visits / diff.days.real
        sort = sorted(rate.items(), key=lambda x:x[1])
        sort.reverse()
        sort = sort[:50]
        for elem in sort:
            if not Node.objects.get(node_id=elem[0]).removed_by_admin or is_admin:
                nodes.append(elem[0])


    if search_type == 'for_you':
        rel_nodes = []
        non_rel_nodes = []
        res = BasicUserDetailAPI.as_view()(request)
        basic_user = BasicUser.objects.get(id=json.loads(res.content.decode())['basic_user_id'])
        for tag in basic_user.semantic_tags.all():
            nodes_q = tag.nodes
            related_nodes_q = tag.related_nodes
            for node in nodes_q:
                if not node.removed_by_admin or is_admin:
                    non_rel_nodes.append(node.node_id)
            for rel_node in related_nodes_q:
                if not rel_node.removed_by_admin or is_admin:
                    rel_nodes.append(rel_node.node_id)
        random.shuffle(non_rel_nodes)
        random.shuffle(rel_nodes)
        nodes = non_rel_nodes + rel_nodes


    if search_type == 'by' or search_type == 'all':
        # print(search_elements)
        search_elements = search.split()
        for el in search_elements:
            res_name = User.objects.filter(first_name__icontains=el)
            res_surname = User.objects.filter(last_name__icontains=el)
            for e in res_name:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    cont_nodes = Contributor.objects.get(user_id=e.id).NodeContributors.all()
                    for node in cont_nodes:
                        if not node.removed_by_admin or is_admin:
                            nodes.append(node.node_id)

            for e in res_surname:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    cont_nodes = Contributor.objects.get(user_id=e.id).NodeContributors.all()
                    for node in cont_nodes:
                        if not node.removed_by_admin or is_admin:
                            nodes.append(node.node_id)

    contributors = []
    if search_type == 'node' or search_type == 'all':
        search_elements = search.split()
        for el in search_elements:
            res = Node.objects.annotate(search=SearchVector("node_title")).filter(node_title__icontains=el)
            for e in res:
                if not e.removed_by_admin or is_admin:
                    nodes.append(e.node_id)

    if search_type == 'author' or search_type == 'all':    # TODO This method is too inefficient
        search_elements = search.split()
        for el in search_elements:
            res_name = User.objects.filter(first_name__icontains=el)
            res_surname = User.objects.filter(last_name__icontains=el)
            for e in res_name:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    contributors.append(e.username)
            for e in res_surname:
                if Contributor.objects.filter(user_id=e.id).count() != 0:
                    contributors.append(e.username)

    if search_type == 'semantic':
        wid = search
        tag = SemanticTag.objects.filter(wid=wid)
        if tag.count() == 0:
            return JsonResponse({'message': 'No tag with this wid is found'}, status=404)
        tag = tag[0]
        nodes_q = tag.nodes
        related_nodes_q = tag.related_nodes
        for node in nodes_q:
            if not node.removed_by_admin or is_admin:
                nodes.append(node.node_id)
        for rel_node in related_nodes_q:
            if not node.removed_by_admin or is_admin:
                nodes.append(rel_node.node_id)

    if search_type == 'random':
        count = Node.objects.count()
        prev = []
        if count < 20:
            c = count
        else:
            c = 20
        i = 0
        while i < c:
            ran = random.randint(0,count-1)
            if ran not in prev:
                prev.append(ran)
                random_node = Node.objects.all()[ran]
                if not random_node.removed_by_admin or is_admin:
                    nodes.append(random_node.node_id)
                    i += 1
    contributors = list(set(contributors))
    if not (search_type == 'latest' or search_type == 'most_read' or search_type == 'for_you'  or search_type == 'trending'):
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
        node_infos.append({'id': node_id, 'title': node.node_title, 'date': node.publish_date, 'authors': authors, 'num_visits' : node.num_visits,'removed_by_admin':node.removed_by_admin})
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
    orcid = None
    if cont.count() != 0:
        orcid  = cont[0].orcid
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

    user_asked_qs = Question.objects.filter(asker=basic_user.id)
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

    semantic_tags = []
    for tag in basic_user.semantic_tags.all():
        semantic_tags.append({'wid': tag.wid,
                              'label': tag.label,
                              'id': tag.id})


    user_type = 'basic_user'
    if  Contributor.objects.filter(id=basic_user.id).exists():
        user_type = 'contributor'
    if  Reviewer.objects.filter(id=basic_user.id).exists():
        user_type = 'reviewer'
    if Admin.objects.filter(id=basic_user.id).exists():
       user_type = 'admin'

    return JsonResponse({'id': basic_user.id,
                         'name':user.first_name,
                         'surname':user.last_name,
                         'orcid': orcid,
                         'bio':basic_user.bio,
                         'nodes': node_infos,
                         'asked_questions':asked_questions,
                         'answered_questions':answered_questions,
                         'user_type': user_type,
                         'is_banned': not user.is_active,
                         'semantic_tags':semantic_tags},status=200)

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

def is_cont_workspace(request):
    try:
        workspace_id = int(request.GET.get("workspace_id"))
    except:
        workspace_id = int(request.POST.get("workspace_id"))
    if not Contributor.objects.filter(pk=request.user.basicuser.pk).exists():
        return False
    if workspace_id is not None:
        return request.user.basicuser.contributor.workspaces.filter(workspace_id=workspace_id).exists()
    return True


def get_workspaces(request):
    res = BasicUserDetailAPI.as_view()(request)
    # basic_user = BasicUser.objects.get(id=json.loads(res.content.decode())['basic_user_id'])
    if not IsContributor().has_permission(request,get_workspaces):
        return JsonResponse({'message':'User is not a Contributor'},status=403)
    # id = int(request.GET.get("user_id"))
    cont = Contributor.objects.filter(id=json.loads(res.content.decode())['basic_user_id'])
    # if cont.count() == 0:
    #     return JsonResponse({'message':'There is no contributor with this id.'},status=404)
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
    pending_review = []
    review_workspace_list = []
    if Reviewer.objects.filter(pk=request.user.basicuser.pk).exists():
        reviwer = Reviewer.objects.filter(id=json.loads(res.content.decode())['basic_user_id'])[0]
        for workspace in reviwer.review_workspaces.all():
            for req in  ReviewRequest.objects.filter(workspace=workspace):
                if req.status == 'A' and req.response == 'P':
                    review_workspace_list.append({'workspace_id': workspace.workspace_id,
                                           'workspace_title': workspace.workspace_title,
                                           'pending': False,
                                                  'request_id':req.id})

        for req in ReviewRequest.objects.filter(receiver=cont):
            workspace = req.workspace
            request_id = req.id
            if req.status == 'P':
                pending_review.append({'workspace_id': workspace.workspace_id,
                                'workspace_title': workspace.workspace_title,
                                'pending': True,
                                'request_id': request_id})

    return JsonResponse({'workspaces':workspace_list,'pending_workspaces':pending,
                         'review_workspaces':review_workspace_list,'pending_review_workspaces':pending_review}, status=200)




def get_workspace_from_id(request):
    id = int(request.GET.get("workspace_id"))
    workspace = Workspace.objects.filter(workspace_id=id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, get_workspace_from_id):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    reviewer = Reviewer.objects.filter(pk=request.user.basicuser)
    cont = Contributor.objects.get(pk=request.user.basicuser)
    reviewer_flag = True
    pending = False
    workspace = workspace[0]
    if reviewer.exists():
        for req in ReviewRequest.objects.filter(receiver=cont):
            if req.workspace.workspace_id == workspace.workspace_id and req.status == 'P':
                reviewer_flag = False
                request_id = req.id
                pending = True
        if workspace in reviewer[0].review_workspaces.all():
            cont = Contributor.objects.filter(pk=request.user.basicuser)[0]
            requests = ReviewRequest.objects.filter(workspace=workspace)
            for request in requests:
                if request.receiver == cont:
                    request_id = request.id
            reviewer_flag = False
    collab_flag = True
    # collab_comment = ''
    for req in CollaborationRequest.objects.filter(receiver=cont):
        if req.workspace.workspace_id == workspace.workspace_id and req.status == 'P':
            collab_flag = False
            pending = True
            request_id = req.id
            # collab_comment = req.comment
    if reviewer_flag and collab_flag:
        request_id = ''
    if collab_flag and reviewer_flag and not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    entries = []
    for entry in workspace.entries.all():
        if not reviewer_flag:
            if entry.is_proof_entry or entry.is_theorem_entry:
                entries.append({'entry_id': entry.entry_id,
                                'entry_date': entry.entry_date,
                                'content': entry.content,
                                'entry_index': entry.entry_index,
                                'is_theorem_entry': entry.is_theorem_entry,
                                'is_final_entry': entry.is_final_entry,
                                'is_proof_entry': entry.is_proof_entry,
                                'is_disproof_entry': entry.is_disproof_entry,
                                'is_editable': entry.is_editable,
                                'entry_number': entry.entry_number, })
        else:
            entries.append({'entry_id':entry.entry_id,
                            'entry_date':entry.entry_date,
                            'content':entry.content,
                            'entry_index':entry.entry_index,
                            'is_theorem_entry':entry.is_theorem_entry,
                            'is_final_entry':entry.is_final_entry,
                            'is_disproof_entry': entry.is_disproof_entry,
                            'is_proof_entry':entry.is_proof_entry,
                            'is_editable':entry.is_editable,
                            'entry_number':entry.entry_number,})
    semantic_tags = []
    for tag in workspace.semantic_tags.all():
        semantic_tags.append({'wid':tag.wid,
                              'label':tag.label,
                              'id':tag.id})
    contributors = []
    for cont in Contributor.objects.filter(workspaces=workspace):
        user = User.objects.get(id=cont.user_id)
        contributors.append({"id": cont.id,
                            "first_name": user.first_name,
                            "last_name": user.last_name,
                            "username": user.username})
    pending_cont = []
    for pend in CollaborationRequest.objects.filter(workspace=workspace):
        cont = pend.receiver
        user = User.objects.get(id=cont.user_id)
        if pend.status == 'P':
            pending_cont.append({"id": cont.id,
                            'request_id':pend.id,
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
    comments = []

    for req in ReviewRequest.objects.filter(workspace=workspace):
        if req.status =='A' and req.response != 'P':
            comments.append({'comment':req.comment,
                             'reviewer':req.receiver.user.username,
                             'response':req.response})

    status = 'workable'
    if workspace.is_published:
        status = 'published'
    elif workspace.is_rejected:
        status = 'rejected'
    elif workspace.is_in_review:
        status = 'in_review'
    elif workspace.is_finalized:
        status = 'finalized'
    if workspace.node == None:
        node_id = ''
    else:
        node_id = workspace.node.node_id
    return JsonResponse({'workspace_id': workspace.workspace_id,
                         'workspace_title':workspace.workspace_title,
                         'workspace_entries': entries,
                         'status':status,
                         'num_approvals':workspace.num_approvals,
                         'semantic_tags':semantic_tags,
                         'contributors':contributors,
                         'pending_contributors':pending_cont,
                        'references':references,
                         'created_at':workspace.created_at,
                         'from_node_id' :  node_id,
                         'request_id' : request_id,
                         'comments':comments,
                         'pending':pending,
                         }, status=200)

def get_semantic_suggestion(request):
    search = request.GET.get("keyword")
    result = SemanticTag.existing_search_results(search)
    if len(result) == 0:
        return JsonResponse({'message': 'There are no nodes with this semantic tag.'}, status=404)
    return JsonResponse({'suggestions': result}, status=200)


@csrf_exempt
def change_workspace_title(request):
    workspace_id = request.POST.get("workspace_id")
    title = request.POST.get("title")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id  field has to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = workspace[0]
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    if workspace.node != None:
        return JsonResponse({'message': 'The title of this workspace can not be changed (created from existing publication)'}, status=403)
    workspace.workspace_title = title
    workspace.save()
    return JsonResponse({'message': 'Workspace title changed successfully'}, status=200)

@csrf_exempt
def set_workspace_proof(request):
    entry_id = request.POST.get("entry_id")
    workspace_id = request.POST.get("workspace_id")
    # is_disproof = request.POST.get("is_disproof")
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
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if entry[0] not in workspace.entries.all():
        return JsonResponse({'message': 'There is no entry with this id in this workspace.'}, status=404)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    entry = entry[0]
    if entry.is_theorem_entry:
        return JsonResponse({'message': 'This Entry is already a theorem entry.'}, status=400)
    if workspace.proof_entry != None:
        workspace.proof_entry.is_proof_entry = False
    workspace.proof_entry = entry
    entry.is_proof_entry = True
    # if is_disproof:
    #     entry.is_disproof_entry= True
    entry.save()
    workspace.save()
    return JsonResponse({'message': 'Proof entry is successfully set.'}, status=200)






@csrf_exempt
def remove_workspace_proof(request):
    workspace_id = request.POST.get("workspace_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id  field has to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    if workspace.proof_entry != None:
        workspace.proof_entry.is_proof_entry = False
        # workspace.proof_entry.is_disproof_entry = False
        workspace.proof_entry.save()
    workspace.proof_entry = None
    workspace.save()
    return JsonResponse({'message': 'Proof entry is successfully removed.'}, status=200)




@csrf_exempt
def set_workspace_disproof(request):
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
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if entry[0] not in workspace.entries.all():
        return JsonResponse({'message': 'There is no entry with this id in this workspace.'}, status=404)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    entry = entry[0]
    if entry.is_theorem_entry:
        return JsonResponse({'message': 'This Entry is already a theorem entry.'}, status=400)
    if entry.is_proof_entry:
        return JsonResponse({'message': 'This Entry is already a proof entry.'}, status=400)
    if workspace.disproof_entry != None:
        workspace.disproof_entry.is_disproof_entry = False
    workspace.disproof_entry = entry
    entry.is_disproof_entry = True
    entry.save()
    workspace.save()
    return JsonResponse({'message': 'Disproof entry is successfully set.'}, status=200)






@csrf_exempt
def remove_workspace_disproof(request):
    workspace_id = request.POST.get("workspace_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id  field has to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    if workspace.disproof_entry != None:
        workspace.disproof_entry.is_disproof_entry = False
        workspace.disproof_entry.save()
    workspace.disproof_entry = None
    workspace.save()
    return JsonResponse({'message': 'Disproof entry is successfully removed.'}, status=200)






@csrf_exempt
def set_workspace_theorem(request):
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
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if entry[0] not in workspace.entries.all():
        return JsonResponse({'message': 'There is no entry with this id in this workspace.'}, status=404)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    entry = entry[0]
    if entry.is_proof_entry:
        return JsonResponse({'message': 'This Entry is already a proof entry.'}, status=400)
    if workspace.node != None:
        return JsonResponse({'message': 'You can not change the theorem entry of this workspace (created from node).'}, status=403)
    if workspace.theorem_entry != None:
        workspace.theorem_entry.is_theorem_entry = False
    workspace.theorem_entry = entry
    entry.is_theorem_entry = True
    entry.save()
    workspace.save()
    return JsonResponse({'message': 'Theorem entry is successfully set.'}, status=200)

@csrf_exempt
def remove_workspace_theorem(request):
    workspace_id = request.POST.get("workspace_id")
    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)
    try:
        workspace_id = int(workspace_id)
    except:
        return JsonResponse({'message': 'workspace_id  field has to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    if workspace.node != None:
        return JsonResponse({'message': 'You can not change the theorem entry of this workspace (created from node).'}, status=403)
    if workspace.theorem_entry != None:
        workspace.theorem_entry.is_theorem_entry = False
        workspace.theorem_entry.save()
    workspace.theorem_entry = None
    workspace.save()
    return JsonResponse({'message': 'Theorem entry is successfully removed.'}, status=200)


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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)



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
    workspace_id = request.POST.get("workspace_id")
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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

    workspace = Workspace.objects.get(workspace_id=workspace_id)
    if workspace.is_finalized:
        return JsonResponse({'message': 'Workspace is already finalized'}, status=403)
    if entry[0] not in workspace.entries.all():
        return JsonResponse({'message': 'There is no entry with this id in this workspace.'}, status=404)

    entry = Entry.objects.get(entry_id=entry_id)
    if entry.is_editable == False:
        return JsonResponse({'message': 'This Entry is not editable'}, status=403)
    if entry.is_final_entry:
        return JsonResponse({'message': 'This Entry is not editable'}, status=403)
    entry.content = content
    entry.save(update_fields=["content"])
    return JsonResponse({'message': 'entry content is updated successfully'}, status=200)
@csrf_exempt
def delete_workspace(request):
    res = BasicUserDetailAPI.as_view()(request)
    workspace_id = request.POST.get("workspace_id")
    # contributor_id = request.POST.get("contributor_id")
    try:
        workspace_id = int(workspace_id)
        # contributor_id = int(contributor_id)
    except:
        return JsonResponse({'message': 'workspace_id  field have to be a integer'}, status=400)
    workspace = Workspace.objects.filter(workspace_id=workspace_id)
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)


    if workspace_id == None or workspace_id == '':
        return JsonResponse({'message': 'workspace_id field can not be empty'}, status=400)

    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

    contributor_id = request.user.basicuser.id
    if contributor_id == None or contributor_id == '':
        return JsonResponse({'message': 'contributor_id field can not be empty'}, status=400)

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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

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
    if workspace.count() == 0:
        return JsonResponse({'message': 'There is no workspace with this id.'}, status=404)
    node = Node.objects.filter(node_id=node_id)
    if node.count() == 0:
        return JsonResponse({'message': 'There is no node with this id.'}, status=404)

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)

    if workspace[0].is_finalized == True:
        return JsonResponse({'message': ' workspace already finalized'}, status=400)
    if node[0] in workspace[0].references.all():
        return JsonResponse({'message': 'this reference already exists in this workspace.'}, status=400)
    workspace[0].references.add(node[0])
    workspace[0].save()

    receivers = node[0].contributors.all()
    email = ""
    check = 0
    for x in receivers:
        if x.email_notification_preference:
            email += str(x.user) + ","
            check = 1
    if check:
        subject = "Referenced node"
        content = "A node of yours is referenced by another contributor!"
        send_notification(email,subject,content)


    return JsonResponse({'message': 'reference added to the workspace successfully.'}, status=200)
@csrf_exempt
def create_workspace(request):
    title = request.POST.get("workspace_title")
    node_id = request.POST.get("node_id")
    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)


    # user_id = request.POST.get("user_id")
    if title == '' or title == None:
        return JsonResponse({'message': 'workspace_title field can not be empty'}, status=400)
    # if user_id == '' or user_id == None:
    #     return JsonResponse({'message': 'user_id field can not be empty'}, status=400)
    # try:
    #     creator = int(user_id)
    # except:
    #     return JsonResponse({'message': 'user_id has to be a integer'}, status=400)
    cont = Contributor.objects.filter(id=request.user.basicuser.id)
    if cont.count() == 0:
        return JsonResponse({'message': 'there is no contributor with this user_id'}, status=400)
    if node_id == None:
        workspace = Workspace.objects.create(workspace_title=title)
    else:
        node = Node.objects.filter(node_id=node_id)
        if not node.exists():
            return JsonResponse({'message': 'there is no node with this node_id'}, status=400)
        node = node[0]
        theorem_entry = Entry.objects.create(content=node.theorem.theorem_content,is_theorem_entry=True,is_editable=False,is_final_entry=True)
        theorem_entry.save()
        workspace = Workspace.objects.create(node=node, workspace_title=node.node_title,theorem_entry=theorem_entry,theorem_posted=True)
        workspace.entries.add(theorem_entry)
        title=node.node_title
        for ref in node.from_referenced_nodes.all():
            workspace.references.add(ref)
        for tag in node.semantic_tags.all():
            workspace.semantic_tags.add(tag)
    workspace.save()
    cont[0].workspaces.add(workspace)
    return JsonResponse({'message': 'Workspace with title ' + title + ' has been added successfully' ,
                         'workspace_id' : workspace.workspace_id}, status=200)
@csrf_exempt
def get_random_node_id(request):
    count = int(request.GET.get("count"))
    node_ids = [node['node_id'] for node in Node.objects.values('node_id')]
    node_list = []
    if count > len(node_ids):
        return JsonResponse({'message': 'There are less nodes than requested number.'}, status=200)
    for i in range(count):
        index = random.randint(0,len(node_ids)-1)
        node_list.append(node_ids[index])
    return JsonResponse({'node_ids': node_list}, status=200)

@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsContributor))
@api_view(['POST'])
def send_collaboration_request(request):
    if not request.user.basicuser.contributor.workspaces.filter(workspace_id=request.data.get('workspace')).exists():
        return Response({"message": "This contributor is not allowed to access this workspace."}, status=403)
    receiver = BasicUser.objects.filter(id=request.data.get('receiver'))[0]
    if receiver.email_notification_preference:
        subject = 'Incoming collaboration request'
        content = 'You have received a collaboration request!'
        receiver = receiver.user
        send_notification(receiver, subject, content)
    serializer = CollaborationRequestSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsContributor))
@api_view(['PUT'])
def update_collab_request_status(request):
    req = CollaborationRequest.objects.filter(pk=request.data.get('id'))
    if not req:
        return Response({"message": "Request not found."}, status=404)
    req = req.first()
    status = request.data.get('status')

    if status not in ["P", "A", "R"]:
        return Response({"message": "Invalid status value."}, status=400)

    if status == "A":
        try:
            req.receiver.workspaces.add(req.workspace)
        except Exception as e:
            return Response({"message": str(e)}, status=500)

    req.status = status
    req.save()
    if req.sender.email_notification_preference:
        subject = "Collaboration Request answered"
        content = "You collaboration request is approved by the contributor!"
        send_notification(str(req.sender.user), subject, content)
    serializer = RequestSerializer(req)
    return Response(serializer.data, status=200)

class IsReviewer(IsContributor):
    def has_permission(self, request, view):
        if not Reviewer.objects.filter(pk=request.user.basicuser.pk).exists():
            return False
        return True

@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsContributor))
@api_view(['POST'])
def send_review_request(request):
    try:
        if not request.user.basicuser.contributor.workspaces.filter(workspace_id=request.data.get('workspace')).exists():
            return Response({"message": "This contributor is not allowed to access this workspace."}, status=403)
        all_reviewers = list(Reviewer.objects.all())
        reviewers = []
        while len(reviewers) < 2 and len(all_reviewers) >= 2:
            rv = random.choice(all_reviewers)
            if rv not in reviewers:
                reviewers.append(rv)
        response_data = {'reviewer1': '', 'reviewer2': ''}

    
        data = {'sender': request.data.get('sender'), 'receiver': reviewers[0].id ,'workspace': request.data.get('workspace')}

        receiver = BasicUser.objects.filter(id=reviewers[0].id)[0]
        if receiver.email_notification_preference:
            subject = 'Incoming review request'
            content = 'You have received a review request!'
            receiver = receiver.user
            send_notification(receiver,subject,content)

        workspace = request.user.basicuser.contributor.workspaces.filter(workspace_id=request.data.get('workspace'))[0]
        if workspace.is_in_review:
            return Response({"message": "This workspace is already under review."}, status=403)
        if workspace.is_published:
            return Response({"message": "This workspace is already published."}, status=403)
        workspace.is_in_review = True
        workspace.is_rejected = False
        workspace.save()
        data = {'sender': request.data.get('sender'), 'receiver': reviewers[0].id, 'workspace': request.data.get('workspace')}

        serializer = ReviewRequestSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            response_data['reviewer1'] = serializer.data

        data = {'sender': request.data.get('sender'), 'receiver': reviewers[1], 'workspace': request.data.get('workspace')}
        serializer = ReviewRequestSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            response_data['reviewer2'] = serializer.data
        else:
            return Response(serializer.errors, status=400)
    except Exception as e:
        return Response({"message": str(e)}, status=500)

    return Response(response_data, status=201)

@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsReviewer))
@api_view(['PUT'])
def update_review_request_status(request):
    req = ReviewRequest.objects.filter(pk=request.data.get('id'))
    if not req:
        return Response({"message": "Request not found."}, status=404)
    req = req.first()
    if request.user.basicuser.id != req.receiver.id:
        return Response({"message": "Unauthorized reviewer"}, status=400)
    if req.status == "R":
        return Response({"message": "The request has already been rejected."}, status=400)

    if req.status == 'A':
        response = request.data.get('response')
        if response not in ["P", "A", "R"]:
            return Response({"message": "Invalid response value."}, status=400)
        if req.response != "P":
            return Response({"message": "The review has already been approved or rejected."}, status=400)
        workspace = req.workspace
        if response == 'A':
            try:
                workspace.num_approvals += 1
                workspace.save()

                if workspace.num_approvals >= 2:
                    workspace.is_published = True
                    workspace.is_in_review = False
                    workspace.is_rejected = False

                    emails = ""
                    check = 0
                    for x in workspace.contributor_set.all():
                        if x.email_notification_preference:
                            emails += str(x.user) + ","
                            check = 1
                    if check:
                        subject = "Workspace approved"
                        content = "Review of your workspace and it is approved with the comment: " + str(req.comment)
                        send_notification(emails,subject,content)

                    if workspace.node == None:
                        node = Node.objects.create(
                            node_title=workspace.workspace_title,
                            publish_date=datetime.date.today(),
                            is_valid=True,
                            num_visits=0,
                            removed_by_admin=False
                        )

                        node.contributors.set(workspace.contributor_set.all())

                        node.from_referenced_nodes.set(workspace.references.all())

                        node.semantic_tags.set(workspace.semantic_tags.all())
                        for entry in workspace.entries.all():
                            if entry.is_proof_entry:
                                new_id = Proof.objects.order_by('-proof_id')[0].proof_id + 1 # TODO THIS PART MUST BE CHANGED.
                                proof = Proof.objects.create(
                                    proof_id = new_id,
                                    proof_title="",
                                    proof_content=entry.content,
                                    is_valid=True,
                                    is_disproof= entry.is_disproof_entry,
                                    publish_date=datetime.date.today(),
                                    removed_by_admin=False,
                                    node=node,
                                )
                                proof.contributors.set(workspace.contributor_set.all())
                                node.proofs.add(proof)
                            elif entry.is_theorem_entry:
                                theorem = Theorem.objects.create(
                                    theorem_title="",
                                    theorem_content=entry.content,
                                    publish_date=datetime.date.today()
                                )
                                theorem.contributors.set(workspace.contributor_set.all())
                                node.theorem = theorem
                    else:
                        node = workspace.node
                        for entry in workspace.entries.all():
                            if entry.is_proof_entry:
                                new_id = Proof.objects.order_by('-proof_id')[0].proof_id + 1  # TODO THIS PART MUST BE CHANGED.
                                proof = Proof.objects.create(
                                    proof_id=new_id,
                                    proof_title="",
                                    proof_content=entry.content,
                                    is_valid=True,
                                    is_disproof=False,
                                    publish_date=datetime.date.today(),
                                    removed_by_admin=False,
                                    node=node
                                )
                                proof.contributors.set(workspace.contributor_set.all())
                                node.proofs.add(proof)
                        for cont in workspace.contributor_set.all():
                            if cont not in node.contributors.all():
                                node.contributors.add(cont)
                        for ref in workspace.references.all():
                            if ref not in node.from_referenced_nodes.all():
                                node.from_referenced_nodes.add(ref)
                        for tag in workspace.semantic_tags.all():
                            if tag not in node.semantic_tags.all():
                                node.semantic_tags.add(tag)
                    for review_request in workspace.reviewrequest_set.all():
                        node.reviewers.add(Reviewer.objects.get(id=review_request.receiver.id))
                    emails = ""
                    check = 0
                    for x in workspace.contributor_set.all():
                        if x.email_notification_preference:
                            emails += str(x.user) + ","
                            check = 1
                    if check:
                        subject = "Workspace approved"
                        content = "Review of your workspace is completed and it is approved with the comment: " + str(req.comment)
                        send_notification(emails, subject, content)
                    serializer = NodeSerializer(data=node)
                    if serializer.is_valid():
                        serializer.save()


            except Exception as e:
                return Response({"message": str(e)}, status=500)
        elif response == 'R':
            workspace.is_rejected = True
            workspace.is_in_review = False
            workspace.is_published = False

            emails = ""
            check = 0
            for x in workspace.contributor_set.all():
                if x.email_notification_preference:
                    emails += str(x.user) + ","
                    check = 1
            if check:
                subject = "Workspace rejected"
                content = "Review of your workspace is completed and it is rejected with the comment: " + str(req.comment)
                send_notification(emails, subject, content)

            for req in ReviewRequest.objects.filter(workspace=workspace):
                if req.status == 'A' and req.response == 'P':
                    workspace.is_in_review = True
                if req.status == 'P':
                    workspace.is_in_review = True

        comment = request.data.get('comment')
        req.comment = comment
        req.response = response
        req.save()

    else:
        status = request.data.get('status')

        workspace = req.workspace

        if status not in ["P", "A", "R"]:
            return Response({"message": "Invalid status value."}, status=400)
        if req.status != "P":
            return Response({"message": "The request has already been approved or rejected."}, status=400)
        if status == 'A':
            reviewer = Reviewer.objects.get(pk=request.user.basicuser.pk)
            reviewer.review_workspaces.add(req.workspace)
        serializer = None
        req.status = status
        req.save()

    serializer = ReviewRequestSerializer(req)
    return Response(serializer.data, status=200)



class AskQuestion(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    
    def post(self,  request):
        node_id = request.data.get('node_id')
        question_content = request.data.get('question_content')
        if not node_id or not question_content:
            return Response({"error": "Node ID and Question Content are required."}, status=status.HTTP_400_BAD_REQUEST)
        try:
            node = Node.objects.get(pk=node_id)
        except Node.DoesNotExist:
            return Response({"error": "Node not found."}, status=status.HTTP_404_NOT_FOUND)
        try:
            asker = BasicUser.objects.get(user_id=request.user.id)
        except BasicUser.DoesNotExist:
            return Response({"error": "BasicUser not found."}, status=status.HTTP_404_NOT_FOUND)
        
        question = Question.objects.create(node=node, asker=asker, question_content=question_content)
        question.save()
        receivers = node.contributors.all()
        emails = ""
        check = 0
        for x in receivers:
            if x.email_notification_preference:
                emails += str(x.user) + ","
                check = 1
        if check:
            subject = "Question asked"
            content = "A question is asked for your node!"
            send_notification(emails, subject, content)
        return Response({"message": "Question submitted successfully.", "QuestionID": question.pk}, status=status.HTTP_201_CREATED)

class AnswerQuestion(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated, IsContributor)

    def post(self, request):
        question_id = request.data.get('question_id')
        answer_content = request.data.get('answer_content')
        if not question_id or not answer_content:
            return Response({"error": "Question ID and Answer Content are required."}, status=status.HTTP_400_BAD_REQUEST)
        try:
            question = Question.objects.get(pk=question_id)
        except Question.DoesNotExist:
            return Response({"error": "Question not found."}, status=status.HTTP_404_NOT_FOUND)
        
        try:
            answerer = Contributor.objects.get(user_id=request.user.id)
        except Contributor.DoesNotExist:
            return Response({"error": "Contributor not found."}, status=status.HTTP_404_NOT_FOUND)
        
        if (question.answer(answer_content, answerer)):
            receiver = str(question.asker.user)
            if question.asker.email_notification_preference:
                subject = "Question answered"
                content = "A question you asked is answered by one of the contributors!"
                send_notification(receiver, subject, content)
            return Response({"message": "Answer submitted successfully."}, status=status.HTTP_201_CREATED)
        else:
            return Response({"error": "Question is not asked to logged Contributor or already answered."}, status=status.HTTP_400_BAD_REQUEST)

class IsAdmin(BasePermission):
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        if not Admin.objects.filter(pk=request.user.basicuser.pk).exists():
            return False
        return True

@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsAdmin))
@api_view(['PUT'])
def update_content_status(request):

    try:
        context = request.data['context']
        content_id = request.data['content_id']
        hide = request.data['hide']

        if context:
            context = context.strip().lower()
            if  context == 'node':
                node = Node.objects.filter(pk=content_id)
                if node.count() > 0:
                    node = node.first()
                    node.removed_by_admin = hide
                    node.save()
                    return Response(NodeSerializer(node).data, status=200)
            elif context == 'question':
                question = Question.objects.filter(pk=content_id)
                if question.count() > 0:
                    question = question.first()
                    question.removed_by_admin = hide
                    question.save()
                    return Response(NodeViewQuestionSerializer(question).data, status=200)

            elif context == 'user':
                user = BasicUser.objects.filter(pk=content_id)
                if user.count() > 0:
                    user = user.first()
                    if hide == 'True' or hide == True:
                        user.user.is_active = False
                    elif hide == 'False' or hide == False:
                        user.user.is_active = True
                    user.user.save()
                    return Response(BasicUserSerializer(user).data, status=200)
    except Exception as e:
        return Response({'message': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsAdmin))
@api_view(['POST'])
def promote_contributor(request):
    try:
        cont_id = request.data.get("cont_id")
        cont = Contributor.objects.filter(id=cont_id)
        if cont.count():
            cont = cont.first()
            if Reviewer.objects.filter(id=cont_id).exists():
                return Response("Already exists!", status=409)
            reviewer = Reviewer(contributor_ptr_id=cont.id)
            reviewer.__dict__.update(cont.__dict__)
            reviewer.save()
            if cont.email_notification_preference:
                subject = "Promotion"
                content = "You are promoted to a reviewer!"
                send_notification(str(cont.user), subject, content)
            return Response(ReviewerSerializer(reviewer).data, status=201)
        return Response("Contributor does not exist!", status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response(str(e), status=500)
            

@authentication_classes((TokenAuthentication,))
@permission_classes((IsAuthenticated, IsAdmin))
@api_view(['DELETE'])
def demote_reviewer(request):
    try:
        reviewer = Reviewer.objects.filter(id=request.query_params.get('reviewer_id'))
        if reviewer.count():
            reviewer = reviewer.first()
            reviewer.delete(keep_parents=True)
            if reviewer.email_notification_preference:
                subject = "Demotion"
                content = "You are demoted to a contributor from a reviewer!"
                send_notification(str(reviewer.user), subject, content)
            return Response("Reviewer demoted to Contributor successfully", status=status.HTTP_204_NO_CONTENT)
            
        return Response("Reviewer does not exist!", status=status.HTTP_404_NOT_FOUND)    
    except Exception as e:
        return Response(str(e), status=500)

class AddUserSemanticTag(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        sm_tag_id = request.data.get('sm_tag_id')
        if not sm_tag_id:
            return Response({"error": "Semantic Tag ID is required."}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = BasicUser.objects.get(pk=request.user.basicuser.pk)
        except:
            return Response({"error": "User not found."}, status=status.HTTP_404_NOT_FOUND)
        try:
            sm_tag = SemanticTag.objects.get(pk=sm_tag_id)
        except:
            return Response({"error": "Semantic Tag not found."}, status=status.HTTP_404_NOT_FOUND)
        
        if user.semantic_tags.filter(pk=sm_tag_id).exists():
            return Response({"error": "User already has this Semantic Tag."}, status=status.HTTP_400_BAD_REQUEST)
        
        user.semantic_tags.add(sm_tag)
        return Response({"message": "Semantic Tag successfully added to user."}, status=status.HTTP_201_CREATED)

def get_related_nodes(request):
    node_id = request.GET.get("node_id")
    node = Node.objects.filter(node_id=node_id)
    if not node.exists():
        return JsonResponse({'message':'There is no node with this node_id.'},status=404)
    node = node[0]
    tags = node.semantic_tags
    nodes = []
    if not tags.exists():
        count = Node.objects.count()
        prev = []
        if count < 20:
            c = count
        else:
            c = 20
        i = 0
        while i < c:
            ran = random.randint(0, count - 1)
            if ran not in prev:
                prev.append(ran)
                random_node = Node.objects.all()[ran]
                if not random_node.removed_by_admin:
                    nodes.append(random_node.node_id)
                    i += 1

    try:
        for tag in tags.all():
            for node in tag.nodes:
                if not node.removed_by_admin:
                    nodes.append(node.node_id)
        if len(nodes) < 20: # TAKES A LOT LONGER FOR RELATED NODES TO BE FOUND SO TRY TO AVOID THEM
            for tag in tags.all():
                if len(nodes) >= 20:
                    break
                for node in tag.related_nodes:
                    if len(nodes) >= 20:
                        break
                    if not node.removed_by_admin:
                        nodes.append(node.node_id)
    except:
        return JsonResponse({'message':'An internal server error occured. Please try again.'},status=500)
    nodes = list(set(nodes))
    node_infos = []
    for node_id in nodes:
        node = Node.objects.get(node_id=node_id)
        authors = []
        for cont in node.contributors.all():
            user = User.objects.get(id=cont.user_id)
            authors.append({'name': user.first_name,
                            'surname': user.last_name, 'username': user.username, 'id': cont.id})
        node_infos.append({'id': node.node_id, 'title': node.node_title, 'date': node.publish_date, 'authors': authors,
                           'num_visits': node.num_visits, 'removed_by_admin': node.removed_by_admin})
    return JsonResponse({'nodes':node_infos},status=200)
@csrf_exempt
def reset_workspace_state(request):
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

    res = BasicUserDetailAPI.as_view()(request)
    if not IsContributor().has_permission(request, delete_entry):
        return JsonResponse({'message': 'User is not a Contributor'}, status=403)
    if not is_cont_workspace(request):
        return JsonResponse({'message': 'User does not have access to this workspace'}, status=403)
    workspace = workspace[0]
    if workspace.is_in_review:
        return JsonResponse({'message': ' workspace is still under review.'}, status=403)

    workspace.is_finalized = False
    workspace.is_in_review = False
    workspace.is_rejected = False

    if workspace.node != None:
        if workspace.theorem_entry != None:
            workspace.theorem_entry.is_editable = True
            workspace.theorem_entry.is_finalized = False
            workspace.theorem_entry.save()
    if workspace.proof_entry != None:
        workspace.proof_entry.is_editable = True
        workspace.proof_entry.is_finalized = False
        workspace.proof_entry.save()
    for entry in workspace.entries.all():
        if entry.is_theorem_entry and workspace.node != None:
            continue
        entry.is_final_entry = False
        entry.is_editable = True
        entry.save()
    workspace.save()
    return JsonResponse({'message': 'workspace state is successfully reset.'}, status=200)