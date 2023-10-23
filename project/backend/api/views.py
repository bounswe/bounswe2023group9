from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from database.serializers import UserSerializer, RegisterSerializer
from django.contrib.auth.models import User
from rest_framework.authentication import TokenAuthentication
from django.http import JsonResponse, HttpRequest
from rest_framework import generics
from database import models

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

def get_profile(request):
    mail = request.GET.get("mail")
    check = User.objects.filter(username=mail)
    if check.count() == 0:
        return JsonResponse({'message': "User with this mail adress does not exist."}, status=400)
    user = User.objects.get(username=mail)
    basic_user = models.BasicUser.objects.get(user_id=user.id)
    cont =  models.Contributor.objects.filter(user_id=user.id)
    nodes = []
    asked_questions = []
    answered_questions = []

    if cont.count() != 0:
        user_nodes = models.Node.objects.filter(contributors=cont[0].id)
        for node in user_nodes:
            nodes.append(node.node_id)
        user_answered_qs = models.Question.objects.filter(answerer=cont[0].id)
        for ans in user_answered_qs:
            answered_questions.append(ans.question_id)
    user_asked_qs = models.Question.objects.filter(asker=user.id)
    for q in user_asked_qs:
        asked_questions.append(q.question_id)
    return JsonResponse({'name':user.first_name,
                         'surname':user.last_name,
                         'bio':basic_user.bio,
                         'nodes': nodes,
                         'asked_questions':asked_questions,
                         'answered_questions':answered_questions},status=200)
