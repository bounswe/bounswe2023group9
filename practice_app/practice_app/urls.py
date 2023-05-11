"""
URL configuration for practice_app project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf.urls.static import static
from django.conf import settings
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

from front_end.views import *

urlpatterns = [
    path("api/", include("api.urls")),
    path("admin/", admin.site.urls),
    path('', home, name='Home'),
    path('search_paper/', search_paper, name='Search Paper'),
    path('search_user/', search_user, name='Search User'),
    path('sign_in/', sign_in, name='Sign In'),
    path('sign_up/', sign_up, name='Sign Up'),
    path('profile_page/', profile_page, name='Profile Page'),
    path('my_lists/', my_lists, name='My Lists'),
    path('following_lists/', following_lists, name='Following Lists'),
    path('list_content/', list_content, name='List Content'),
    path('paper_content/', paper_content, name='Paper Content'),
    path('follow_requests/', follow_requests, name='Follow Requests'),
    path('followers/', followers, name='Follow Requests'),
    path('following/', following, name='Follow Requests'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)

urlpatterns += staticfiles_urlpatterns()
