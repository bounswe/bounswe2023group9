from logging import warning
from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse, HttpRequest
import json
from api.views import *
from api.models import *



def home(request):
    return HttpResponse("<h1>Hey this is a home page</h1>")

def search_paper(request):
    logged_in = 1
    if request.user.is_anonymous:
        logged_in = 0
    context = {'page': 'Search Paper', 'logged_in' : logged_in}
    return render(request, "pages/search_paper.html", context)

def search_user(request):
    if request.user.is_anonymous:
        return redirect("/sign_in/")
    context = {'page': 'Search User', 'logged_in' : 1}

    if request.method == "POST": 
        if request.POST.get("id") == "search": # if the search button clicked
            name = request.POST.get("name")
            users = User.objects.filter(first_name__istartswith = name ).values()
            context["users"] = users
        elif request.POST.get("id") == "follow": # if follow button is clicked
            followed_user = request.POST.get("followed_user")
            follow_request = HttpRequest()
            follow_request.method = 'POST'
            follow_request.user = request.user
            follow_request.META = request.META
            follow_request.session = request.session
            follow_request.POST.update({"followed_username":followed_user})
            follow_user(follow_request) #post follow_user             
    return render(request, "pages/search_user.html", context)


def sign_up(request):
    # warning will be used to warn the user if the credentials are invalid or for any other warning
    context = {'page': 'Sign Up', 'warning': ""}

    if request.user.is_authenticated:  # if the user is authenticated, then redirect to search paper page
        return redirect("/search_paper/")

    if request.method == "POST":  # if the sign in button clicked
        username = request.POST.get("user_name")
        password = request.POST.get("password")

        #create a request to call user_registration
        signup_request = HttpRequest()
        signup_request.method = 'POST'
        signup_request.user = request.user
        signup_request.META = request.META
        signup_request.session = request.session
        signup_request.headers = {"username": username, "password": password}
        signup_response = user_registration(signup_request)

        if signup_response.status_code == 200:  # if the user is created, redirect to  sign in page
            return redirect("/sign_in/")
        else:
            context["warning"] = "Invalid credentials!"  # if not registered
    return render(request, "pages/sign_up.html", context)

def sign_in(request):

    # warning will be used to warn the user if the credentials are invaild or for any other warning
    context = {'page': 'Sign In', 'warning': ""}
    if request.user.is_authenticated:  # if the user is authenticated, then redirect to search paper page
        return redirect("/search_paper/")

    if request.method == "POST":  # if the sign in button clicked
        username = request.POST.get("user_name")
        password = request.POST.get("password")

        login_request = HttpRequest()
        login_request.method = 'POST'
        login_request.user = request.user
        login_request.META = request.META
        login_request.session = request.session
        login_request.headers = {"username": username, "password": password}
        login_response = log_in(login_request)

        if login_response.status_code == 200:  # if the user is registered, redirect to search paper page
            return redirect("/search_paper/")
        else:
            context["warning"] = "Invalid credentials!"  # if not registered

    return render(request, "pages/sign_in.html", context)

def sign_out(request):
    log_out(request)
    return redirect('/sign_in/')




def profile_page(request):
    if request.user.is_anonymous:
        return redirect("/sign_in/")

    profile = {
        'orcid_id': request.user.username,
        'first_name': request.user.first_name,
        'last_name': request.user.last_name,
        'date_joined': request.user.date_joined,
        'interests': [],
    }

    if len(UserInterest.objects.filter(user=request.user)) > 0:
        profile['interests'] = [user_interest.interest for user_interest in UserInterest.objects.filter(user=request.user)]

    context = {'page': 'Profile Page', 'profile': profile , 'logged_in' : 1}
    return render(request, "pages/profile_page.html", context)


def my_lists(request):
    user = request.user
    if request.user.is_anonymous: # if not signed in
        return redirect("/sign_in/")

    context = {'page': 'My Lists', 'logged_in' : 1, "warning": ""} # default context

    if request.method == "POST": # if the user tries to create a new paper list
        given_title = request.POST.get("paper_list_title") # get the specified new paper list title

        # call your api to crate the new paper list
        create_request = HttpRequest()
        create_request.method = 'POST'
        create_request.user = request.user
        create_request.META = request.META
        create_request.session = request.session
        create_request.POST = {"list_title": given_title}
        create_response = create_paper_list(create_request)

        if create_response.status_code == 200:  # if the paper list created successfully
            context["warning"] = "Paper list created successfully!"
        else: # if failed
            context["warning"] = "Paper list couldn't created!"  

    p_lists = PaperList.objects.filter(owner = user) # fetch the paper lists owned by the user from database
    context["paper_lists"] = p_lists # add to the context

    return render(request, "pages/my_lists.html", context)


def following_lists(request):
    
    user = request.user

    if user.is_anonymous:
        return redirect('/sign_in/')
    
    saved_lists = PaperList.objects.filter(saver=user)
    context = {'page': 'Following Lists', 'lists': saved_lists}
    return render(request, "pages/following_lists.html", context)


def list_content(request):
    if request.user.is_anonymous:
        return redirect("/sign_in/")
    context = {'page': 'List Content', 'logged_in' : 1}
    return render(request, "pages/list_content.html", context)


def paper_content(request):
    logged_in = 1
    if request.user.is_anonymous:
        logged_in = 0
    context = {'page': 'Paper content','logged_in':logged_in}
    return render(request, "pages/paper_content.html", context)

def followers(request):
    if request.user.is_anonymous:
        return redirect("/sign_in/")
    followers = get_followers(request)
    followers = json.loads(followers.content)['followers']
    context = {'page': 'Followers', 'followers': followers , 'logged_in' : 1}
    return render(request, "pages/followers.html", context)



def following(request):
    if request.user.is_anonymous:
        return redirect("/sign_in/")
    following = get_following(request)
    following = json.loads(following.content)['following']
    context = {'page': 'Following', 'followings': following, 'logged_in' : 1}
    return render(request, "pages/following.html", context)





def follow_requests(request):
    if request.user.is_anonymous:
        return redirect("/sign_in/")
    reqs = [
        {'sender': 'NAME1'},
        {'sender': 'NAME2'},
        {'sender': 'NAME3'},
        {'sender': 'NAME4'}
    ]
    context = {'page': 'Follow Requests', 'follow_requests': reqs, 'logged_in' : 1}
    return render(request, "pages/follow_requests.html", context)




