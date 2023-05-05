from django.urls import path
from . import views

urlpatterns = [
    path("serp-api/q=<str:search>&num=<int:number>/", views.serp_api, name="serp_api"),
    path("serp-api/q=<str:search>/", views.serp_api, name="serp_api_default"),
]