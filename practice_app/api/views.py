from django.shortcuts import render
import requests
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
# Create your views here.

def orcid_api(request):

    user_id = request.GET.get('user_id')
    Headers = {"Accept": "application/json"}

    if user_id == None or user_id == '':
        return JsonResponse({"status":"ORCID ID should be provided as user_id"}, status = 404)
    
    api_request = requests.get("https://orcid.org/"+user_id, headers=Headers)

    if api_request.status_code != 200:
        return JsonResponse({"status":"Invalid ORCID ID"}, status = 404)
    else:
        try:
            api_request = api_request.json()
        except:
            return JsonResponse({"status":"Invalid ORCID ID"}, status = 404)
        response = {}
        response["user_id"] = user_id
        response["name"] = api_request["person"]["name"]["given-names"]["value"]
        if api_request["person"]["name"]["family-name"] != None:
            response["surname"] = api_request["person"]["name"]["family-name"]["value"]
        else:
            response["surname"] = None
        return JsonResponse(response)
    

def log_in(request):

    username = request.GET.get("username")
    password = request.GET.get("password")

    if username == None or username == '':
        return JsonResponse({"status":"ORCID ID should be provided."}, status = 404)
    
    if password == None or password == '':
        return JsonResponse({"status":"Password should be provided."}, status = 404)
    
    user = authenticate(request, username=username, password=password)

    if user is not None:
        login(request, user)
        return JsonResponse({"status":"User logged in."}, status = 200)

    else:
        return JsonResponse({"status":"Authentication failed"}, status = 404)


def log_out(request):

    logout(request)
    return JsonResponse({"status":"User logged out."}, status = 200)
    
def user_registration(request):

    user_id = request.GET.get('user_id')
    password = request.GET.get('password')
    name = request.GET.get('name')
    surname = request.GET.get('surname')

    if user_id == None or user_id == '':
        return JsonResponse({"status":"ORCID ID should be provided."}, status = 404)
    
    if password == None or password == '':
        return JsonResponse({"status":"Password should be provided."}, status = 404)
    
    if name == None or name == '':
        return JsonResponse({"status":"Name should be provided."}, status = 404)
    
    if surname == None or surname == '':
        return JsonResponse({"status":"Surname should be provided."}, status = 404)
    
    if len(User.objects.filter(username= user_id)) == 0:
        user = User.objects.create_user(username= user_id, password= password, first_name= name,last_name= surname )
        return JsonResponse({"status":"User created"}, status = 200)
    
    else:
        return JsonResponse({"status":"Username is already taken."}, status = 404)

