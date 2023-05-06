from django.urls import path

from . import views

app_name = "api"
urlpatterns = [
    path('eric/', views.eric_index, name='eric_index'),
    path('eric/papers/', views.eric_papers, name='eric_papers'),
    
    ]