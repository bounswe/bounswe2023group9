from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse, HttpRequest

from api.views import *


def home(request):
    return HttpResponse("<h1>Hey this is a home page</h1>")


def search_paper(request):
    context = {'page': 'Search Paper'}
    return render(request, "pages/search_paper.html", context)


def search_user(request):
    context = {'page': 'Search User'}
    return render(request, "pages/search_user.html", context)


def sign_in(request):
    """r_username = "omari"
    r_password = "123456"
    User.objects.create_user(
        username=r_username, password=r_password, first_name="nam", last_name="surname")"""
    context = {'page': 'Sign In', 'warning': ""}
    if request.user.is_authenticated:
        return redirect("/search_paper/")

    if request.method == "POST":
        username = request.POST.get("user_name")
        password = request.POST.get("password")

        login_request = HttpRequest()
        login_request.method = 'POST'
        login_request.user = request.user
        login_request.META = request.META
        login_request.session = request.session
        login_request.headers = {"username": username, "password": password}
        login_response = log_in(login_request)
        if login_response.status_code == 200:
            context = {'page': 'Search Paper'}
            return redirect("/search_paper/")
        else:
            context["warning"] = "Invalid credentials!"

    return render(request, "pages/sign_in.html", context)


def profile_page(request):
    context = {'page': 'Profile Page'}
    return render(request, "pages/profile_page.html", context)


def my_lists(request):
    papers = [
        {'title': '<PAPER TITLE1>', 'abstract': "<ABSTRACT1>", 'year': 2000},
        {'title': '<PAPER TITLE2>', 'abstract': "<ABSTRACT2>", 'year': 2001},
        {'title': '<PAPER TITLE3>', 'abstract': "<ABSTRACT3>", 'year': 2002},
        {'title': '<PAPER TITLE4>', 'abstract': "<ABSTRACT4>", 'year': 2003},
    ]
    context = {'page': 'My Lists', "papers": papers}
    return render(request, "pages/my_lists.html", context)


def following_lists(request):
    lists = [
        'list1',
        'list2',
        'list3',
        'list4',
    ]
    context = {'page': 'Following Lists', 'lists': lists}
    return render(request, "pages/following_lists.html", context)


def list_content(request):
    context = {'page': 'List Content'}
    return render(request, "pages/list_content.html", context)


def paper_content(request):
    context = {'page': 'Paper content'}
    return render(request, "pages/paper_content.html", context)


def follow_requests(request):
    reqs = [
        {'sender': 'NAME1'},
        {'sender': 'NAME2'},
        {'sender': 'NAME3'},
        {'sender': 'NAME4'}
    ]
    context = {'page': 'Follow Requests', 'follow_requests': reqs}
    return render(request, "pages/follow_requests.html", context)
