from django.test import TestCase, Client
from unittest import skip
import requests
import json
from . import api_keys
# Create your tests here.

class DOAJ_API_Tester(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests for DOAJ_API Completed Successfully')

    def test_doaj_api(self):
        doaj_api_response = requests.get('https://doaj.org/api/search/articles/einstein,relativity?page=1&pageSize=3')
        self.assertEquals(doaj_api_response.status_code, 200, "DoajApi didn't work as supposed to")
        doaj_api_response = doaj_api_response.json()['results']
        
        response = self.c.get("/api/doaj-api/?query=einstein,relativity&rows=3")
        self.assertEquals(response.status_code, 200)
        response_dict = response.json()
        self.assertIn('status_code', response_dict.keys())
        self.assertIn('count', response_dict.keys())
        count = 0
        for result in response_dict['results']:
            self.assertIn('id', result.keys())
            self.assertIn('source', result.keys())
            self.assertIn('position', result.keys())
            self.assertIn('authors',result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('title',result.keys())
            self.assertEquals(result['id'], doaj_api_response[count]["id"])
            self.assertEquals(result['source'], 'DOAJ')
            self.assertEquals(result['date'], doaj_api_response[count]["created_date"])
            self.assertEquals(result['abstract'], doaj_api_response[count]["bibjson"]["abstract"])
            self.assertEquals(result['title'], doaj_api_response[count]["bibjson"]["title"])
            self.assertEquals(result['url'], doaj_api_response[count]["bibjson"]["link"][0]["url"])
            count += 1

# tests for the GET API which uses CORE API
class core_api_test_cases(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('Tests for GET requests using CORE API completed!')

    def test_unexpected_responses(self):
        # missing title case
        temp = self.c.get("/api/core")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing title param with url '/api/core'.")
        self.assertEquals(json.loads(temp.content.decode("UTF-8")),
                          {'status': "'title' query param is required!"}, "Test failed: content test for missing title param with url '/api/core'.")

        # missing title case with rows
        temp = self.c.get("/api/core?rows=5")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing title param with url '/api/core?rows=5'.")
        self.assertEquals(json.loads(temp.content.decode("UTF-8")),
                          {'status': "'title' query param is required!"}, "Test failed: content test for missing title param with url '/api/core?rows=5'.")

        # missing title case with some random params
        temp = self.c.get("/api/core?randomNonexistParam=randomVal")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing title param with url '/api/core?randomNonexistParam=randomVal'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "'title' query param is required!"}, "Test failed: content test for missing title param with url '/api/core?randomNonexistParam=randomVal'.")

        # invalid rows case
        temp = self.c.get("/api/core?title=vision%20transformers&rows=abc")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for invalid rows param with url '/api/core?title=vision%20transformers&rows=abc'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "'rows' query param must be numeric if exist!"}, "Test failed: content test for invalid rows param with url '/api/core?title=vision%20transformers&rows=abc'.")

        # title not found case
        temp = self.c.get("/api/core?title=sdfhgaskdfgajksdhgf")
        self.assertEquals(
            temp.status_code, 404, "Test failed: status_code test for title not-found with url '/api/core?title=sdfhgaskdfgajksdhgf'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "There is no such content with the specified title on this source!"}, "Test failed: content test for title not-found with url '/api/core?title=sdfhgaskdfgajksdhgf'.")

    def test_expected_responses(self):
        # normal successful request with no rows
        temp = self.c.get("/api/core?title=hardware%20accelerators")
        self.assertEquals(
            temp.status_code, 200, "Test failed: status_code test for success request with url '/api/core?title=hardware%20accelerators'.")
        resp = json.loads(temp.content.decode("UTF-8"))
        self.assertEquals(bool(
            resp["results"]), True, "Test failed: results test for success request with url '/api/core?title=hardware%20accelerators'.")
        for i, r in enumerate(resp["results"]):
            self.assertEquals(bool(
                r["id"]), True, "Test failed: result id test for success request with url '/api/core?title=hardware%20accelerators' for the result#: " + str(i) + "result: " + str(r))
            self.assertEquals(
                r["source"], "core.ac.uk", "Test failed: source test for success request with url '/api/core?title=hardware%20accelerators' for the result#: " + str(i) + "result: " + str(r))
            self.assertEquals(bool(
                r["title"]), True, "Test failed: title test for success request with url '/api/core?title=hardware%20accelerators' for the result#: " + str(i) + "result: " + str(r))

        # normal successful request with valid rows
        temp = self.c.get("/api/core?title=hardware%20accelerators&rows=4")
        self.assertEquals(
            temp.status_code, 200, "Test failed: status_code test for success request with url '/api/core?title=hardware%20accelerators&rows=4'.")
        resp = json.loads(temp.content.decode("UTF-8"))
        self.assertEquals(bool(
            resp["results"]), True, "Test failed: results test for success request with url '/api/core?title=hardware%20accelerators&rows=4'.")
        for i, r in enumerate(resp["results"]):
            self.assertEquals(bool(
                r["id"]), True, "Test failed: result id test for success request with url '/api/core?title=hardware%20accelerators&rows=4' for the result#: " + str(i) + "result: " + str(r))
            self.assertEquals(
                r["source"], "core.ac.uk", "Test failed: source test for success request with url '/api/core?title=hardware%20accelerators&rows=4' for the result#: " + str(i) + "result: " + str(r))
            self.assertEquals(bool(
                r["title"]), True, "Test failed: title test for success request with url '/api/core?title=hardware%20accelerators&rows=4' for the result#: " + str(i) + "result: " + str(r))


class google_scholar_test_cases(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests for Google Scholar Completed Successfully')

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
        
class ZenodoTestCases(TestCase):

    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests for Zenodo API Completed Successfully')

    def test_zenodo_api(self):
        response = self.c.get("/api/zenodo/?title=test&rows=3")
        self.assertEquals(response.status_code, 200)
        response_content = response.json()['results']
        self.assertEquals(len(response_content), 3)
        count = 0
        for result in response_content:
            self.assertIn('source', result.keys())
            self.assertEquals(result['source'], 'Zenodo')
            self.assertIn('authors', result.keys())
            self.assertIn('id', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('position', result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('title', result.keys())
            self.assertEquals(response_content[count]['title'], result['title'])
            self.assertEquals(response_content[count]['url'], result['url'])
            self.assertEquals(response_content[count]['position'], result['position'])
            count += 1

class SemanticScholarTestCase(TestCase):
    def setUp(self):
        self.client = Client()

    def tearDown(self):
        print('GET Tests of Semantic Scholar Completed Successfully')

    def test_404_responses(self):
        self.assertEquals(self.client.get("/api/semantic-scholar/?title=").status_code, 404)
        self.assertEquals(self.client.get("/api/semantic-scholar/?").status_code, 404)
        self.assertEquals(self.client.get("/api/semantic-scholar/").status_code, 404)
        self.assertEquals(self.client.get("/api/semantic-scholar/?rows=9").status_code, 404)
        self.assertEquals(self.client.get("/api/semantic-scholar/title=coffee").status_code, 404)
        self.assertEquals(self.client.get("/api/semantic-scholar/?title=&").status_code, 404)

    
    def test_results(self):
        
        semantic_scholar_api_response = requests.get('https://api.semanticscholar.org/graph/v1/paper/search?query=covid&fields=title,authors,url&offset=0&rows=3')
        self.assertEquals(semantic_scholar_api_response.status_code,200,"It didn't work as supposed to")
        semantic_scholar_api_response = semantic_scholar_api_response.json()['data']
        
        response = self.client.get("/api/semantic-scholar/?title=covid&rows=3")
        self.assertEquals(response.status_code,200)
        response_content = response.json()['results']
        self.assertEquals(len(response_content),3)

        for count,result in enumerate(response_content):
            self.assertIn('source',result.keys())
            self.assertEquals(result['source'],'semantic_scholar')
            self.assertIn('authors',result.keys())
            self.assertIn('id', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('title',result.keys())
            self.assertEquals(semantic_scholar_api_response[count]['title'],result['title'])
            self.assertEquals(semantic_scholar_api_response[count]['url'], result['url'])
            self.assertEquals(count, result['position'])
