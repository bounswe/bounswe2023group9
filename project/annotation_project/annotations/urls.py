from django.urls import path

from .views  import *

urlpatterns = [
    path('get_annotation/', matched_annotations_get_view, name='get_annotation'),
    path('annotation/<annotation_id>/', get_annotation_by_id, name='get_annotation_by_id'),
    path('create_annotation/', create_annotation, name='create_annotation'),
]


