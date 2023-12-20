from django.test import TestCase, Client
from django.urls import reverse
from datetime import datetime
import json

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

        source2 = Source.objects.create(uri='http://example.com/source2')
        body2 = Body.objects.create(value='Annotation Test Conten2t')
        creator2 = Creator.objects.create(name='testcreator2@example.com')
        selector2 = Selector.objects.create(start=0, end=5, source=source2)
        self.annotation2 = Annotation.objects.create(
            body=body2,
            target=selector2,
            creator=creator2,
            created=datetime.now(),
        )
    
    def tearDown(self):
        Annotation.objects.all().delete()
        Selector.objects.all().delete()
        Creator.objects.all().delete()
        Body.objects.all().delete()
        Source.objects.all().delete()
        print("All Annotation Get API Tests Completed")

    #TODO: update matched annotations test
        
    def test_get_matched_annotations(self):
        client = Client()
    
        url = reverse('get_annotation')
        data = {
            'creator': [
                'testcreator@example.com',
                'testcreator2@example.com']
        }
        response = client.get(url, data, format='json')

        self.assertEqual(response.status_code, 200, response.json())
        
        response = response.json()
        self.assertEqual(len(response), 2)
        response = response[1]
        self.assertEqual(response['@context'], 'http://www.w3.org/ns/anno.jsonld')
        self.assertEqual(response['id'],f'http://13.51.55.11:8001/annotations/annotation/{self.annotation2.id}')
        self.assertEqual(response['type'], self.annotation2.type)
        self.assertEqual(response['body'], {
            'type': self.annotation2.body.type,
            'format': self.annotation2.body.format,
            'language': self.annotation2.body.language,
            'value': self.annotation2.body.value,
        })
        self.assertEqual(response['target'], {
            'id': self.annotation2.target.source.uri,
            'type': 'text',
            'selector': {
                'type': self.annotation2.target.type,
                'start': self.annotation2.target.start,
                'end': self.annotation2.target.end,
            }
            })
        self.assertTrue(response['creator']['id'], self.annotation2.creator.name)
        self.assertIn('created', response)

    def test_get_annotation_by_id(self):
        #Test the annotation response format
        client = Client()

        url = reverse('get_annotation_by_id', args=[self.annotation.id])

        response = client.get(url)
        self.assertEqual(response.status_code, 200)

        response = response.json()
        self.assertEqual(response['@context'], 'http://www.w3.org/ns/anno.jsonld')
        self.assertEqual(response['id'],f'http://13.51.55.11:8001/annotations/annotation/{self.annotation.id}')
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

class AnnotationPostTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.url = reverse('create_annotation')
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        self.json = {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "body": {
                "type": "TextualBody",
                "format": "text/html",
                "language": "en",
                "value": "Turing machine is great!!!"
            },
            "target": {
                "id": "http://13.51.205.39/node/55#theorem",
                "type": "text",
                "selector": {
                    "type": "TextPositionSelector",
                    "start": 30,
                    "end": 45
                }
            },
            "creator": {
                "id": "http://13.51.205.39/profile/cemsay@gmail.com",
                "type": "Person"
            }
        }
        self.body = {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "body": str(self.json['body']),
            "target": str(self.json['target']),
            "creator": str(self.json['creator'])
        }
        self.body_missing_body = {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "target": str(self.json['target']),
            "creator": str(self.json['creator'])
        }
        self.body_missing_target = {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "body": str(self.json['body']),
            "creator": str(self.json['creator'])
        }
        self.body_missing_creator = {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "body": str(self.json['body']),
            "target": str(self.json['target']),
        }

    def tearDown(self):
        Annotation.objects.all().delete()
        Selector.objects.all().delete()
        Creator.objects.all().delete()
        Body.objects.all().delete()
        Source.objects.all().delete()
        print("All Annotation Post API Tests Completed")

    def test_create_annotation(self):
        response = self.client.post(self.url, data=self.body_missing_body, headers=self.headers)
        self.assertEqual(response.status_code, 400, "Missing body field test failed. expected 400, got " + str(response.status_code))
        response = self.client.post(self.url, data=self.body_missing_target, headers=self.headers)
        self.assertEqual(response.status_code, 400, "Missing target field test failed. expected 400, got " + str(response.status_code))
        response = self.client.post(self.url, data=self.body_missing_creator, headers=self.headers)
        self.assertEqual(response.status_code, 400, "Missing creator field test failed. expected 400, got " + str(response.status_code))

        response = self.client.post(self.url, data=self.body, headers=self.headers, content_type='application/json')
        self.assertEqual(response.status_code, 200, "Successful create annotation test failed. expected 200, got " + str(response.status_code))

        records = Annotation.objects.filter(id=response.json()['id'])
        self.assertEqual(len(records), 1, "Successful create annotation test (database insertion) failed. expected 1 row, got " + str(len(records)))

        if records:
            record = records[0]
            data = response.json()
            self.assertEqual(data['body'], self.json['body'], "Successful create annotation test (body) failed. expected " + str(self.json['body']) + ", got " + str(data['body']))
            self.assertEqual(data['target'], self.json['target'], "Successful create annotation test (target) failed. expected " + str(self.json['target']) + ", got " + str(data['target']))
            self.assertEqual(data['creator'], self.json['creator'], "Successful create annotation test (creator) failed. expected " + str(self.json['creator']) + ", got " + str(data['creator']))
            self.assertEqual(data['id'], "http://13.51.55.11:8001/annotations/annotation/" + str(record.pk), "Successful create annotation test (id) failed. expected " + "http://13.51.55.11:8001/annotations/annotation/" + str(record.pk))
