from django.test import TestCase, Client
from django.urls import reverse
from datetime import datetime

from .models import *

class AnnotationGetTest(TestCase):
    def setUp(self):
        source = Source.objects.create(uri='http://example.com/source1')
        body = Body.objects.create(value='Annotation Test Content')
        creator = Creator.objects.create(name='testcreator@example.com')
        selector = Selector.objects.create(start=0, end=5, source=source)
        self.annotation = Annotation.objects.create(
            body=body,
            target=selector,
            creator=creator,
            created=datetime.now(),
        )

    def test_get_annotation_by_id(self):
        #Test the annotation response format
        client = Client()

        url = reverse('get_annotation_by_id', args=[self.annotation.id])

        response = client.get(url)
        self.assertEqual(response.status_code, 200)

        response = response.json()
        self.assertEqual(response['@context'], 'http://www.w3.org/ns/anno.jsonld')
        self.assertTrue(response['id'].endswith(f'annotation{self.annotation.id}'))
        self.assertEqual(response['type'], self.annotation.type)
        self.assertEqual(response['body'], {
            'type': self.annotation.body.type,
            'format': self.annotation.body.format,
            'language': self.annotation.body.language,
            'value': self.annotation.body.value,
        })
        self.assertEqual(response['target'], {
            'id': self.annotation.target.source.uri,
            'type': 'text',
            'selector': {
                'type': self.annotation.target.type,
                'start': self.annotation.target.start,
                'end': self.annotation.target.end,
            }
            })
        self.assertTrue(response['creator']['id'], self.annotation.creator.name)
        self.assertIn('created', response)

