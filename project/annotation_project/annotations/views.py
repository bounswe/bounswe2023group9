from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view

from .models import *
from .serializers import *

@api_view(['GET'])
def get_annotation(request):
    id = request.GET.get('id')
    if id is None:
        for annotation in Annotation.objects.all():
            return Response(AnnotationSerializer(annotation).data)
        
    return Response({"message": "No content"}, status=status.HTTP_200_OK)
