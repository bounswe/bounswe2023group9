from django.test import TestCase,Client
from unittest import skip
import requests
from . import api_keys
# Create your tests here.
class google_scholar_test_cases(TestCase):
    def setUp(self):
        self.c = Client()


    def tearDown(self):
        print('GET Tests Completed Successfully')

    def test_404_responses(self):
        self.assertEquals(self.c.get("/api/serp-api/?title=").status_code, 404)
        self.assertEquals(self.c.get("/api/serp-api/?").status_code, 404)
        self.assertEquals(self.c.get("/api/serp-api/").status_code, 404)
        self.assertEquals(self.c.get("/api/serp-api/?rows=5").status_code, 404)
        self.assertEquals(self.c.get("/api/serp-api/title=sad").status_code, 404)
        self.assertEquals(self.c.get("/api/serp-api/?title=&").status_code, 404)

    @skip('limited use for this api')
    def test_results(self):
        serp_api_response = requests.get('https://serpapi.com/search.json?engine=google_scholar&q=test&hl=en&num=3&api_key=' + api_keys.api_keys['serp_api'])
        self.assertEquals(serp_api_response.status_code,200,"SerpApi didn't work as supposed to")
        serp_api_response = serp_api_response.json()['organic_results']
        response = self.c.get("/api/google-scholar/?title=test&rows=3")
        self.assertEquals(response.status_code,200)
        response_content = response.json()['results']
        self.assertEquals(len(response_content),3)
        count = 0
        for result in response_content:
            self.assertIn('source',result.keys())
            self.assertEquals(result['source'],'google_scholar')
            self.assertIn('authors',result.keys())
            self.assertIn('id', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('pos', result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('title',result.keys())
            self.assertEquals(serp_api_response[count]['title'],result['title'])
            self.assertEquals(serp_api_response[count]['link'], result['url'])
            self.assertEquals(serp_api_response[count]['position'], result['pos'])
            count += 1

class EricPapersTestCase(TestCase):
    def setUp(self):
        self.client = Client()

    def test_invalid_title(self):
        #no search_title is provided
        response = self.client.get('/api/eric/')
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json()['message'], 'A paper title must be given.')

        #empty search_title is provided
        response = self.client.get('/api/eric/?title=')
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json()['message'], 'A paper title must be given.')


    def test_valid_title(self):
        # valid title is provided

        field_count = 8

        response = self.client.get('/api/eric/?title=nanotechnology')

        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.json()['papers'][0]), field_count)
        self.assertContains(response, 'id')
        self.assertContains(response, 'title')
        self.assertContains(response, 'author')
        self.assertContains(response, 'abstract')
        self.assertContains(response, 'source')
        self.assertContains(response, 'date')
        self.assertContains(response, 'url')
        self.assertContains(response, 'position')


    def test_invalid_rows(self):
        # invalid rows is provided
        response = self.client.get('/api/eric/?title=education&rows=abc')
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json()['message'], 'Row count must be valid.')


    def test_valid_rows(self):
        # test when valid title and rows are provided

        field_count = 8

        response = self.client.get('/api/eric/?title=education&rows=10')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.json()['papers'][0]), field_count)
        self.assertContains(response, 'id')
        self.assertContains(response, 'title')
        self.assertContains(response, 'author')
        self.assertContains(response, 'abstract')
        self.assertContains(response, 'source')
        self.assertContains(response, 'date')
        self.assertContains(response, 'url')
        self.assertContains(response, 'position')
class zenodo_test_cases(TestCase):

    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests Completed Successfully')

    def test_zenodo_api(self):
        ACCESS_TOKEN = api_keys.api_keys['ZENODO_API_KEY']
        request = requests.get('https://zenodo.org/api/records',
                               params={'q': 'test', 'sort': 'bestmatch', 'size': 3,
                                       'access_token': ACCESS_TOKEN})
        self.assertEquals(request.status_code, 200, "Zenodo API didn't work as supposed to")
        response = self.c.get("/zenodo?search_title=test&rows=3")
        self.assertEquals(response.status_code, 200)
        response_content = response.json()['results']
        self.assertEquals(len(response_content), 3)
        count = 0
        for result in response_content:
            self.assertIn('source', result.keys())
            self.assertEquals(result['source'], 'zenodo')
            self.assertIn('authors', result.keys())
            self.assertIn('id', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('position', result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('title', result.keys())
            self.assertEquals(response[count]['title'], result['title'])
            self.assertEquals(response[count]['link'], result['url'])
            self.assertEquals(response[count]['position'], result['pos'])
            count += 1
class zenodo_test_cases(TestCase):

    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests Completed Successfully')

    def test_zenodo_api(self):
        ACCESS_TOKEN = api_keys.api_keys['ZENODO_API_KEY']
        request = requests.get('https://zenodo.org/api/records',
                               params={'q': 'test', 'sort': 'bestmatch', 'size': 3,
                                       'access_token': ACCESS_TOKEN})
        self.assertEquals(request.status_code, 200, "Zenodo API didn't work as supposed to")
        response = self.c.get("/zenodo?search_title=test&rows=3")
        self.assertEquals(response.status_code, 200)
        response_content = response.json()['results']
        self.assertEquals(len(response_content), 3)
        count = 0
        for result in response_content:
            self.assertIn('source', result.keys())
            self.assertEquals(result['source'], 'zenodo')
            self.assertIn('authors', result.keys())
            self.assertIn('id', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('position', result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('title', result.keys())
            self.assertEquals(response[count]['title'], result['title'])
            self.assertEquals(response[count]['link'], result['url'])
            self.assertEquals(response[count]['position'], result['pos'])
            count += 1