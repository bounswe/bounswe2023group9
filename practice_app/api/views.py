from django.shortcuts import render
import requests
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
# Create your views here.

# GET api/orcid_api/
# Utilizes the orcid api to get user credentials
# params -> user_id 
# response type: {"user_id": string, "name": string, "surname": string}
def orcid_api(request):
    
    # user_id should be a valid ORCID ID
    user_id = request.GET.get('user_id')

    Headers = {"Accept": "application/json"}

    if user_id == None or user_id == '':
        return JsonResponse({"status":"ORCID ID should be provided as user_id"}, status = 404)
    
    # third party api call 
    # returns a json file that contains all public information related with given ORCID ID
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

# POST api/log_in/
# implements log in functionality
# username and password should be provided in Headers
def log_in(request):
    
    username = request.headers["username"]
    password = request.headers["password"]

    if username == None or username == '':
        return JsonResponse({"status":"ORCID ID should be provided."}, status = 404)
    
    if password == None or password == '':
        return JsonResponse({"status":"Password should be provided."}, status = 404)
    
    # Check user database to authenticate the user with given credentials. Return a user if valid username and password is given.
    user = authenticate(request, username=username, password=password)

    # if the user is authenticated log in by built-in login function
    if user is not None:
        login(request, user)
        return JsonResponse({"status":"User logged in."}, status = 200)

    else:
        return JsonResponse({"status":"Authentication failed"}, status = 404)

# GET api/log_out/
# get user to log out by built-in logout function
def log_out(request):

    logout(request)
    return JsonResponse({"status":"User logged out."}, status = 200)

# POST api/user_registration
# username and password should be in headers
# username should be unique
# name and surname should be provided in data
# username, name, password must be provided, surname is optional
def user_registration(request):

    user_id = request.headers["username"]
    password = request.headers['password']
    name = request.POST['name']
    surname = request.POST['surname']

    if user_id == None or user_id == '':
        return JsonResponse({"status":"ORCID ID should be provided."}, status = 404)
    
    if password == None or password == '':
        return JsonResponse({"status":"Password should be provided."}, status = 404)
    
    if name == None or name == '':
        return JsonResponse({"status":"Name should be provided."}, status = 404)
    
    if surname == None:
        surname = " "
    
    # Check if the user_id is already taken. 
    if len(User.objects.filter(username= user_id)) == 0:
        # Create user on User model by using create_user function.
        # Used create_user() instead of create() since create_user() handles password encryption
        User.objects.create_user(username= user_id, password= password, first_name= name,last_name= surname )
        return JsonResponse({"status":"User created"}, status = 200)
    
    else:
        return JsonResponse({"status":"Username is already taken."}, status = 404)

