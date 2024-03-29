from logging import warning
from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse, HttpRequest
import json
from api.views import *
from api.models import *



def home(request):
    return HttpResponse("<h1>Hey this is a home page</h1>")

def search_paper(request):
    lists = {}
    papers = {}
    if request.method == "POST":  # if the search button clicked
        if request.POST.get('id') == "search":
            database = request.POST.get("database")
            query = request.POST.get("search_paper")
            rows = request.POST.get("rows")
            search_request = HttpRequest()
            search_request.method = 'POST'
            search_request.user = request.user
            search_request.META = request.META
            search_request.session = request.session
            search_request.GET.update({"title": query, "rows": rows})

            if request.user.is_authenticated:
                req = HttpRequest()
                db = database
                if database == 'semantic_scholar':
                    db = 'semantic-scholar'
                if database == 'eric_papers':
                    db = 'eric'
                if database == 'google_scholar':
                    db = 'google-scholar'
                req.POST.update({"title": query, "rows": rows, "db": db})
                req.user = request.user
                req.META = request.META
                req.session = request.session
                req.method = 'POST'
                post_papers(req)

            if database == "semantic_scholar":
                response = semantic_scholar(search_request)
            elif database == "eric_papers":
                response = eric_papers(search_request)
            elif database == "zenodo":
                response = zenodo(search_request)
            elif database == "doaj":
                response = doaj_get(search_request)
            elif database == "google_scholar":
                response = google_scholar(search_request)
            elif database == "core":
                response = core_get(search_request)
            elif database == "nasa-sti":
                response = nasa_sti(search_request)

            if request.user.is_authenticated:
                lists = PaperList.objects.filter(owner = request.user).values()
            papers = json.loads(response.content.decode()).get('results')

        elif request.POST.get('id') == "add_list":
            if request.user.is_anonymous:
                return redirect("/sign_in/") 
            list_id = request.POST.get("list_id")
            third_party_paper_id = request.POST.get("paper_id")
            paper_id = str(Paper.objects.filter(third_party_id = third_party_paper_id).values()[0]["paper_id"])
            add_paper_request = HttpRequest()
            add_paper_request.method = 'POST'
            add_paper_request.user = request.user
            add_paper_request.META = request.META
            add_paper_request.session = request.session
            add_paper_request.POST.update({'list_id':list_id, 'paper_id':paper_id})
            add_paper_to_list(add_paper_request)

        elif request.POST.get('id') == "like":
            if request.user.is_anonymous:
                return redirect("/sign_in/")
            third_party_paper_id = request.POST.get("paper_id")
            paper_id = str(Paper.objects.filter(third_party_id = third_party_paper_id).values()[0]["paper_id"])
            like_paper_request = HttpRequest()
            like_paper_request.method = 'POST'
            like_paper_request.user = request.user
            like_paper_request.META = request.META
            like_paper_request.session = request.session
            like_paper_request.POST.update({'paper_id':paper_id})
            like_paper(like_paper_request)
    logged_in = 1
    if request.user.is_anonymous:
        logged_in = 0
    context = {'page': 'Search Paper', 'warning': "","papers": papers ,"lists":lists, 'logged_in' : logged_in}
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
    context = {'page': 'Profile Page', 'profile': profile, 'logged_in': 1}
    if request.method == "POST":  # if the button clicked
            newInterest = request.POST.get("newInterest")
            add_request = HttpRequest()
            add_request.method = 'POST'
            add_request.user = request.user
            add_request.META = request.META
            add_request.session = request.session
            add_request.headers = {"username": request.user.username, "password": request.user.password}
            add_request.POST.update({'interest': newInterest})
            add_response = add_interest(add_request)
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
    context = {'page': 'Following Lists', 'lists': saved_lists, 'logged_in':1}
    return render(request, "pages/following_lists.html", context)


def list_content(request, paper_list_id):
    # if user is anonymous should not see list contents
    if request.user.is_anonymous: 
        return redirect("/sign_in/")
    context = {'page': 'List Content', 'logged_in' : 1}
    #check if the PaperList object exists
    if len(PaperList.objects.filter(id = paper_list_id)) >0 :
        #find paper_list object
        paper_list = PaperList.objects.filter(id = paper_list_id)[0]
        print(paper_list)
        print(paper_list.paper.all())
        # add all papers to context
        context["papers"] = paper_list.paper.all()
        context["list_title"] = paper_list.list_title
    return render(request, "pages/list_content.html", context)

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

    if request.method == "POST": 
        button_value = request.POST.get('accept') or request.POST.get('reject')
        if button_value:
            action, sender_username = button_value.split('$')
        if action == 'accept': # if the accept button is clicked
            # call your api to accept the follow request
            accept_request = HttpRequest()
            accept_request.method = 'POST'
            accept_request.user = request.user
            accept_request.META = request.META
            accept_request.session = request.session
            accept_request.POST.update({"sender_id": sender_username, "receiver_id": request.user.username})
            accept_follow_request(accept_request) #post accept_follow_request       
        elif action == 'reject': # if the accept button is clicked
            # call your api to reject the follow request
            reject_request = HttpRequest()
            reject_request.method = 'POST'
            reject_request.user = request.user
            reject_request.META = request.META
            reject_request.session = request.session
            reject_request.POST.update({"sender_id": sender_username, "receiver_id": request.user.username})
            reject_follow_request(reject_request) #post reject_follow_request

    follow_requests = FollowRequest.objects.filter(receiver=request.user, status='pending')
    formatted_requests = [{'sender': request.sender.username} for request in follow_requests]
    context = {'page': 'Follow Requests', 'follow_requests': formatted_requests, 'logged_in' : 1}

    return render(request, "pages/follow_requests.html", context)

