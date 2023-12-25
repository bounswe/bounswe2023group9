from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods, etag
from django.views.decorators.vary import vary_on_headers
import json
import hashlib

from .models import *

def serialize_annotation(annotation):
    return {
        '@context': 'http://www.w3.org/ns/anno.jsonld',
        'id': f'http://13.51.55.11:8001/annotations/annotation/{annotation.id}',
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
            'id': annotation.creator.name,
            'type': annotation.creator.type,
        },
        'created': annotation.created,
    }

@csrf_exempt
@require_http_methods(['GET', 'HEAD'])
@vary_on_headers('Accept')
def matched_annotations_get_view(request):
    source_uris = request.GET.getlist('source')
    creator_names = request.GET.getlist('creator')
    filtering_conditions = {}

    if len(source_uris) > 0:
        filtering_conditions['target__source__uri__in'] = source_uris
    if len(creator_names) > 0:
        filtering_conditions['creator__name__in'] = creator_names
    try:
        matched_annotations = Annotation.objects.filter(**filtering_conditions)
        response = JsonResponse({'message': 'No annotation found!'}, status=404)
        if len(matched_annotations) > 0:
            matched_data = [
                serialize_annotation(annotation) for annotation in matched_annotations
            ]
            response =  JsonResponse(matched_data, status=200, safe=False)
            response['ETag'] = '"_{}"'.format(hashlib.md5(response.content).hexdigest())

    except Exception as e:
        response = JsonResponse({'message': str(e)}, status=500)
    finally:
        response.headers['Content-Type'] = 'application/ld+json; profile="http://www.w3.org/ns/anno.jsonld"'
        response.headers['Link'] = '<http://www.w3.org/ns/ldp#Resource>; rel="type"'
        response['Allow'] = 'GET,OPTIONS,HEAD'
        response['Vary'] = 'Accept'
        return response

@csrf_exempt
@require_http_methods(['GET', 'HEAD', 'DELETE'])
@vary_on_headers('Accept')
def get_annotation_by_id(request, annotation_id):
    print(request.method)
    if request.method == 'DELETE':
        try:
            annotation = Annotation.objects.filter(id=annotation_id)
            if len(annotation) == 0:
                response = JsonResponse({'message': 'No annotation found!'}, status=404)
            else:
                annotation = annotation.first()
                annotation.delete()
                response = JsonResponse({'message' : 'Annotation deleted successfully'}, status=204)
        except Exception as e:
            response = JsonResponse({'message': str(e)}, status=500)
        finally:
            return response

    try:
        annotation = Annotation.objects.get(id=annotation_id)
        response = JsonResponse({'message': 'No annotation found!'}, status=404)
        if annotation:
            response_data = serialize_annotation(annotation)
            response = JsonResponse(response_data, status=200)
            response['ETag'] = '"_{}"'.format(hashlib.md5(response.content).hexdigest())

    except Exception as e:
        response = JsonResponse({'message': str(e)}, status=500)
    finally:
        response.headers['Content-Type'] = 'application/ld+json; profile="http://www.w3.org/ns/anno.jsonld"'
        response.headers['Link'] = '<http://www.w3.org/ns/ldp#Resource>; rel="type"'
        response['Allow'] = 'GET,OPTIONS,HEAD,DELETE'
        response['Vary'] = 'Accept'
        return response
    
@csrf_exempt
def create_annotation(request):
    try:
        body = request.POST.get('body')
        if not body:
            return JsonResponse({'message': 'body must be given!'}, status=400)
        body = json.loads(body)
        
        value = body.get('value')
        if value is None:
            return JsonResponse({'message': 'body value must be given!'}, status=400)
        
        body_type = body.get('type')
        body_format = body.get('format')
        body_language = body.get('language')

        target = request.POST.get('target')
        if not target:
            return JsonResponse({'message': 'target must be given!'}, status=400)
        target = json.loads(target)
        
        target_id = target.get('id')
        if not target_id:
            return JsonResponse({'message': 'target id must be given!'}, status=400)
        
        selector = target.get('selector')
        if not selector:
            return JsonResponse({'message': 'target selector must be given!'}, status=400)
        
        selector_type = selector.get('type')
        selector_start = selector.get('start')
        if selector_start is None:
            return JsonResponse({'message': 'selector start must be given!'}, status=400)

        selector_end = selector.get('end')
        if selector_end is None:
            return JsonResponse({'message': 'selector end must be given!'}, status=400)
        
        creator = request.POST.get('creator')
        if not creator:
            return JsonResponse({'message': 'creator must be given!'}, status=400)
        creator = json.loads(creator)
        
        creator_id = creator.get('id')
        if not creator_id:
            return JsonResponse({'message': 'creator id must be given!'}, status=400)
        
        creator_type = creator.get('type')

        body_object = Body.objects.create(
            value=value
        )

        if body_type:
            body_object.type = body_type

        if body_format:
            body_object.format = body_format

        if body_language:
            body_object.language = body_language
        
        body_object.save()
        
        source_object, created = Source.objects.get_or_create(
            uri=target_id
        )

        selector_object = Selector.objects.create(
            start=selector_start,
            end=selector_end,
            source=source_object
        )

        if selector_type:
            selector_object.type = selector_type
        
        selector_object.save()

        creator_object = Creator.objects.create(
            name=creator_id
        )

        if creator_type:
            creator_object.type = creator_type
        
        creator_object.save()

        annotation_type = request.POST.get('type')
        annotation_object = Annotation.objects.create(
            body=body_object,
            target=selector_object,
            creator=creator_object
        )

        if annotation_type:
            annotation_object.type = annotation_type
        
        annotation_object.save()
        
        return JsonResponse(data = serialize_annotation(annotation_object), status=201)
    except Exception as e:
        print(str(e))
        if "duplicate key value violates unique constraint" in str(e):
            return JsonResponse({'message': 'Annotation already exists!'}, status=400)
        return JsonResponse({'message': "Internal server error"}, status=500)
