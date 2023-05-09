
from django.urls import path
from . import views

app_name = "api"
urlpatterns = [
    path("doaj-api/", views.doaj_get, name="doaj_api"),
    path("google-scholar/", views.google_scholar, name="google-scholar"),
    path('eric/', views.eric_papers, name='eric_papers'),
    path("orcid_api/", views.orcid_api, name="orcid_api"),
    path("log_in/", views.log_in, name="log_in"),
    path("log_out/", views.log_out, name="log_out"),
    path("user_registration/", views.user_registration, name="user_registration"),
]
