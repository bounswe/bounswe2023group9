from django.urls import path

from . import views

app_name = "api"
urlpatterns = [
    path('eric/', views.eric_papers, name='eric_papers'),
    
    ]