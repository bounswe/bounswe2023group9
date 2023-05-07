
from django.urls import path
from . import views

app_name = "api"
urlpatterns = [
    path("orcid_api/", views.orcid_api, name="orcid_api"),
    path("log_in/", views.log_in, name="log_in"),
    path("log_out/", views.log_out, name="log_out"),
    path("user_registration/", views.user_registration, name="user_registration"),
]