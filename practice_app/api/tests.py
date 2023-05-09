from django.test import TestCase, Client
from unittest import skip
import requests
import json
import time
from . import api_keys
# Create your tests here.


# tests for the GET API which uses CORE API
class core_api_test_cases(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('Tests for GET requests using CORE API completed successfully!')

    def unexpected_responses(self):

        temp = self.c.get("/api/core")  # missing keyword case
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing keyword param with url '/api/core'.")
        self.assertEquals(json.loads(temp.content.decode("UTF-8")),
                          {'status': "'keyword' query param is required!"}, "Test failed: content test for missing keyword param with url '/api/core'.")

        # missing keyword case with limit
        temp = self.c.get("/api/core?limit=5")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing keyword param with url '/api/core?limit=5'.")
        self.assertEquals(json.loads(temp.content.decode("UTF-8")),
                          {'status': "'keyword' query param is required!"}, "Test failed: content test for missing keyword param with url '/api/core?limit=5'.")

        # missing keyword case with some random params
        temp = self.c.get("/api/core?randomNonexistParam=randomVal")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing keyword param with url '/api/core?randomNonexistParam=randomVal'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "'keyword' query param is required!"}, "Test failed: content test for missing keyword param with url '/api/core?randomNonexistParam=randomVal'.")

        # invalid limit case
        temp = self.c.get("/api/core?keyword=vision%20transformers&limit=abc")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for invalid limit param with url '/api/core?keyword=vision%20transformers&limit=abc'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "'limit' query param must be numeric if exist!"}, "Test failed: content test for invalid limit param with url '/api/core?keyword=vision%20transformers&limit=abc'.")

        time.sleep(65)  # sleep to wait for the rate limit of the third party
        # keyword not found case
        temp = self.c.get("/api/core?keyword=sdfhgaskdfgajksdhgf")
        self.assertEquals(
            temp.status_code, 404, "Test failed: status_code test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "There is no such content with the specified keyword on this source!"}, "Test failed: content test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf'.")

        time.sleep(2)
        # keyword not found case with empty limit
        temp = self.c.get("/api/core?keyword=sdfhgaskdfgajksdhgf&limit")
        self.assertEquals(
            temp.status_code, 404, "Test failed: status_code test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf&limit'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "There is no such content with the specified keyword on this source!"}, "Test failed: content test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf&limit'.")

        time.sleep(2)
        # keyword not found case with empty limit
        temp = self.c.get("/api/core?keyword=sdfhgaskdfgajksdhgf&limit=")
        self.assertEquals(
            temp.status_code, 404, "Test failed: status_code test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf&limit='.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "There is no such content with the specified keyword on this source!"}, "Test failed: content test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf&limit='.")

        time.sleep(65)
        # keyword not found key with a valid limit
        temp = self.c.get("/api/core?keyword=sdfhgaskdfgajksdhgf&limit=2")
        self.assertEquals(
            temp.status_code, 404, "Test failed: status_code test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf&limit=2'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "There is no such content with the specified keyword on this source!"}, "Test failed: content test for keyword not-found with url '/api/core?keyword=sdfhgaskdfgajksdhgf&limit=2'.")

    def expected_responses(self):
        time.sleep(65)  # sleep to wait for the rate limit of the third party
        # normal successful request with no limit
        temp = self.c.get("/api/core?keyword=hardware%20accelerators")
        self.assertEquals(
            temp.status_code, 200, "Test failed: status_code test for success request with url '/api/core?keyword=hardware%20accelerators'.")
        resp = json.loads(temp.content.decode("UTF-8"))
        self.assertEquals(bool(
            resp["results"]), True, "Test failed: results test for success request with url '/api/core?keyword=hardware%20accelerators'.")

        time.sleep(65)  # sleep to wait for the rate limit of the third party
        # normal successful request with empty limit
        temp = self.c.get("/api/core?keyword=hardware%20accelerators&limit")
        self.assertEquals(
            temp.status_code, 200, "Test failed: status_code test for success request with url '/api/core?keyword=hardware%20accelerators&limit'.")
        resp = json.loads(temp.content.decode("UTF-8"))
        self.assertEquals(bool(
            resp["results"]), True, "Test failed: results test for success request with url '/api/core?keyword=hardware%20accelerators&limit'.")

        time.sleep(2)
        # normal successful request with empty limit
        temp = self.c.get("/api/core?keyword=hardware%20accelerators&limit=")
        self.assertEquals(
            temp.status_code, 200, "Test failed: status_code test for success request with url '/api/core?keyword=hardware%20accelerators&limit='.")
        resp = json.loads(temp.content.decode("UTF-8"))
        self.assertEquals(bool(
            resp["results"]), True, "Test failed: results test for success request with url '/api/core?keyword=hardware%20accelerators&limit='.")

        time.sleep(2)
        # normal successful request with valid limit
        temp = self.c.get("/api/core?keyword=hardware%20accelerators&limit=4")
        self.assertEquals(
            temp.status_code, 200, "Test failed: status_code test for success request with url '/api/core?keyword=hardware%20accelerators&limit=4'.")
        resp = json.loads(temp.content.decode("UTF-8"))
        self.assertEquals(bool(
            resp["results"]), True, "Test failed: results test for success request with url '/api/core?keyword=hardware%20accelerators&limit=4'.")

        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")

        # too many requests case
        temp = self.c.get("/api/core?keyword=hardware%20accelerators&limit=10")
        self.assertEquals(
            temp.status_code, 204, "Test failed: status_code test for too many requests request with url '/api/core?keyword=hardware%20accelerators&limit=10'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': 'The server is too busy for this request. Please try again later.'}, "Test failed: content test for too many requests request with url '/api/core?keyword=hardware%20accelerators&limit=10'.")


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
        self.assertEquals(self.c.get(
            "/api/serp-api/title=sad").status_code, 404)
        self.assertEquals(self.c.get(
            "/api/serp-api/?title=&").status_code, 404)

    @skip('limited use for this api')
    def test_results(self):
        serp_api_response = requests.get(
            'https://serpapi.com/search.json?engine=google_scholar&q=test&hl=en&num=3&api_key=' + api_keys.api_keys['serp_api'])
        self.assertEquals(serp_api_response.status_code, 200,
                          "SerpApi didn't work as supposed to")
        serp_api_response = serp_api_response.json()['organic_results']
        response = self.c.get("/api/google-scholar/?title=test&rows=3")
        self.assertEquals(response.status_code, 200)
        response_content = response.json()['results']
        self.assertEquals(len(response_content), 3)
        count = 0
        for result in response_content:
            self.assertIn('source', result.keys())
            self.assertEquals(result['source'], 'google_scholar')
            self.assertIn('authors', result.keys())
            self.assertIn('id', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('pos', result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('title', result.keys())
            self.assertEquals(
                serp_api_response[count]['title'], result['title'])
            self.assertEquals(serp_api_response[count]['link'], result['url'])
            self.assertEquals(
                serp_api_response[count]['position'], result['pos'])
            count += 1
