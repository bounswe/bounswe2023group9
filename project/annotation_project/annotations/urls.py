from django.urls import path

from .views  import *

urlpatterns = [
   path('get_annotation/', get_annotation, name='get_annotation'),
]


