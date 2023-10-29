from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from database.serializers import UserSerializer, RegisterSerializer, ChangePasswordSerializer
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth.models import User
from rest_framework.authentication import TokenAuthentication
from django.http import JsonResponse
from rest_framework import generics, status
from django.contrib.postgres.search import SearchVector
from database.models import *

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
        print(search_elements)
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
        res_authors.append({'name': User.objects.get(id=cont.user_id).first_name,
                        'surname': User.objects.get(id=cont.user_id).last_name, 'username': cont.user.username})
    node_infos = []
    for node_id in nodes:
        node = Node.objects.get(node_id=node_id)
        authors = []
        for cont in node.contributors.all():
            user = User.objects.get(id=cont.user_id)
            authors.append({'name': User.objects.get(id=cont.user_id).first_name,
                            'surname': User.objects.get(id=cont.user_id).last_name, 'username': user.username})
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
            answered_questions.append(ans.id)
    user_asked_qs = Question.objects.filter(asker=user.id)
    for q in user_asked_qs:
        asked_questions.append(q.id)
    node_infos = []
    for node_id in nodes:
        node = Node.objects.get(node_id=node_id)
        authors = []
        for cont in node.contributors.all():
            user = User.objects.get(id=cont.user_id)
            authors.append({'name': user.first_name, 'surname': user.last_name, 'username': user.username})
        node_infos.append({'id':node_id,'title':node.node_title,'date':node.publish_date,'authors':authors})
    # TODO QUESTION RETURNS SHOULD BE CHANGED IN THE FUTURE.
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