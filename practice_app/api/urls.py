from django.urls import path
from . import views

urlpatterns = [
    path("google-scholar/", views.google_scholar, name="google-scholar"),
    path("core", views.core_get, name="core")
]
