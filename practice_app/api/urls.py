from django.urls import path
from . import views

urlpatterns = [
    path("doaj-api/", views.doaj_get, name="doaj_api"),
]