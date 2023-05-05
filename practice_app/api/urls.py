from django.urls import path
from . import views

urlpatterns = [
    path("serp-api/title=<str:search>&rows=<int:number>/", views.serp_api, name="serp_api"),
    path("serp-api/title=<str:search>/", views.serp_api, name="serp_api_default"),
]