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





