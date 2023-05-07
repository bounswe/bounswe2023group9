from django.urls import path
from . import views

urlpatterns = [
    path("google-scholar/", views.google_scholar, name="google-scholar"),
    path("core/<str:keyword>/<int:limit>", views.core_get)
]
