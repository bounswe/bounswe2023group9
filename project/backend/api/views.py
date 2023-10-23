from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from database.serializers import UserSerializer, RegisterSerializer
from django.contrib.auth.models import User
from rest_framework.authentication import TokenAuthentication
from rest_framework import generics
from django.http import JsonResponse, HttpRequest
from django.contrib.postgres.search import SearchVector
from database import models

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





def get_proof_from_id(request):
    id = int(request.GET.get("proof_id"))
    proof = models.Theorem.objects.filter(theorem_id=id)
    if proof.count() == 0:
        return JsonResponse({'message':'There is no proof with this id.'},status=404)
    return JsonResponse({'proof_id': proof[0].proof_id,
                         'proof_title': proof[0].proof_title,
                         'proof_content': proof[0].proof_content,
                         'is_valid': proof[0].is_valid,
                         'is_disproof': proof[0].is_disproof,
                         'publish_date': proof[0].publish_date,
                         }, status=200)



def get_theorem_from_id(request):
    id = int(request.GET.get("theorem_id"))
    theorem = models.Theorem.objects.filter(theorem_id=id)
    if theorem.count() == 0:
        return JsonResponse({'message':'There is no theorem with this id.'},status=404)

    return JsonResponse({'theorem_id': theorem[0].theorem_id,
                         'theorem_title': theorem[0].theorem_title,
                         'theorem_content': theorem[0].theorem_content,
                         'publish_date': theorem[0].publish_date,
                         }, status=200)


def get_node_from_id(request):
    id = int(request.GET.get("node_id"))
    node = models.Node.objects.filter(node_id=id)
    if node.count() == 0:
        return JsonResponse({'message':'There is no node with this id.'},status=404)
    proofs = models.Proof.objects.filter(node=node)
    proof_l = []
    for proof in proofs:
        proof_l.append(proof.proof_id)
    return JsonResponse({'node_title':node[0].node_title,
                         'theorem': node[0].theorem.theorem_id,
                         'publish_date': node[0].publish_date,
                         'is_valid':node[0].is_valid,
                         'annotations' : node[0].annotations,
                         'wiki_tags':node[0].wiki_tags,
                         'num_visits':node[0].num_visits,
                         'semantic_tags':node[0].semantic_tags,
                         'reviewers':node[0].reviewers,
                         'contributors':node[0].contributors,
                         'proofs':proof_l,
                         }, status=200) # REFERENCE NODES MISSING

def search(request):
    search = request.GET.get("query")
    search_type = request.GET.get("type")
    if search == None or search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=400)
    if search_type == None or search_type == "":
        return JsonResponse({'status': 'Type to search must be given.'}, status=400)
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
    contributors = []
    if search_type == 'node' or search_type == 'both':
        for el in search_elements:
            res = models.Node.objects.annotate(search=SearchVector("node_title")).filter(node_title__icontains=el)
            for e in res:
                nodes.append(e.node_id)
    if search_type == 'author' or search_type == 'both':    # TODO This method is too inefficient
        for el in search_elements:
            res_name = models.User.objects.filter(first_name__icontains=el)
            res_surname = models.User.objects.filter(last_name__icontains=el)
            for e in res_name:
                if models.Contributor.objects.filter(user_id=e.id).count() != 0:
                    contributors.append(e.username)
            for e in res_surname:
                if models.Contributor.objects.filter(user_id=e.id).count() != 0:
                    contributors.append(e.username)
    return JsonResponse({'nodes' : nodes , 'authors' : list(set(contributors))},status=200)
