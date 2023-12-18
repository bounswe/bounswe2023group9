from django.shortcuts import render
from django.http import JsonResponse

from .models import *


def serialize_annotation(annotation, scheme, host):
    return {
        '@context': 'http://www.w3.org/ns/anno.jsonld',
        'id': f'{scheme}://{host}/annotation{annotation.id}',
        'type': annotation.type,
        'body': {
            'type': annotation.body.type,
            'format': annotation.body.format,
            'language': annotation.body.language,
            'value': annotation.body.value,
        },
        'target': {
            'id': annotation.target.source.uri,
            'type': 'text',
            'selector': {
                'type': annotation.target.type,
                'start': annotation.target.start,
                'end': annotation.target.end,
            },
        },
        'creator': {
            'id': f'http://13.51.205.39/profile/{annotation.creator.name}',
            'type': annotation.creator.type,
        },
        'created': annotation.created,
    }


def matched_annotations_get_view(request):
    source_uri = request.GET.get('source')
    creator_name = request.GET.get('creator')

    filtering_conditions = {}

    if source_uri:
        filtering_conditions['target__source__uri__iexact'] = source_uri
    if creator_name:
        filtering_conditions['creator__name__iexact'] = creator_name
    try:
        matched_annotations = Annotation.objects.filter(**filtering_conditions)

        if len(matched_annotations) == 0:
            return JsonResponse({'message': 'No annotation found!'}, status=404)

        matched_data = [
            serialize_annotation(annotation, request.scheme, request.get_host()) for annotation in matched_annotations
        ]

        return JsonResponse(matched_data, status=200, safe=False)
    except Exception as e:
        return JsonResponse({'message': str(e)}, status=500)


def get_annotation_by_id(request, annotation_id):
    try:
        annotation = Annotation.objects.get(id=annotation_id)

        if not annotation:
            return JsonResponse({'message': 'No annotation found!'}, status=404)
        return JsonResponse(data = serialize_annotation(annotation, request.scheme, request.get_host()), status=200)
    except Exception as e:
        return JsonResponse({'message': str(e)}, status=500)
