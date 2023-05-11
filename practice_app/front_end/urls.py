from django.urls import path

from .views  import *

urlpatterns = [
    path('', home, name='Home'),
    path('search_paper/', search_paper, name='Search Paper'),
    path('search_user/', search_user, name='Search User'),
    path('sign_in/', sign_in, name='Sign In'),
    path('sign_up/', sign_up, name='Sign Up'),
    path('sign_out/', sign_out, name='Sign Out'),
    path('profile_page/', profile_page, name='Profile Page'),
    path('my_lists/', my_lists, name='My Lists'),
    path('following_lists/', following_lists, name='Following Lists'),
    path('list_content/', list_content, name='List Content'),
    path('paper_content/', paper_content, name='Paper Content'),
    path('follow_requests/', follow_requests, name='Follow Requests'),
    path('followers/', followers, name='Followers'),
    path('following/', following, name='Following'),
]