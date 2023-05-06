from django.urls import path
from . import views

urlpatterns = [
    path("serp-api/", views.serp_api, name="serp_api"),
]