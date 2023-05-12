from django.test import TestCase, Client
from unittest import skip
import requests
import json
from . import api_keys, models
from django.contrib.auth.models import User
from . import models
# Create your tests here.

# TEST CASE FOR DOAJ API
class DOAJ_API_Tester(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests for DOAJ_API Completed Successfully')

    def test_doaj_api(self):
        doaj_api_response = requests.get('https://doaj.org/api/search/articles/einstein,relativity?page=1&pageSize=10')
        self.assertEquals(doaj_api_response.status_code, 200, "DoajApi didn't work as supposed to")
        doaj_api_response = doaj_api_response.json()['results']
        
        response = self.c.get("/api/doaj-api/?title=einstein,relativity&rows=10")
        self.assertEquals(response.status_code, 200)
        response_dict = response.json()
        self.assertIn('status_code', response_dict.keys())
        self.assertIn('count', response_dict.keys())
        for index, result in enumerate(response_dict['results']):
            self.assertIn('id', result.keys())
            self.assertIn('source', result.keys())
            self.assertIn('position', result.keys())
            self.assertIn('authors',result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('title',result.keys())

            self.assertEquals(result['id'], doaj_api_response[index]["id"])
            self.assertEquals(result['source'], 'DOAJ')
            self.assertEquals(result['date'], int(doaj_api_response[index]["created_date"][0:4]))

            if "bibjson" in doaj_api_response[index].keys():
                if "abstract" in doaj_api_response[index]["bibjson"].keys():
                    self.assertEquals(result['abstract'], doaj_api_response[index]["bibjson"]["abstract"])
                else:
                    self.assertEquals(result['abstract'], "NO ABSTRACT")
                if "title" in doaj_api_response[index]["bibjson"].keys():
                    self.assertEquals(result['title'], doaj_api_response[index]["bibjson"]["title"])
                else:
                    self.assertEquals(result['title'], "NO TITLE")
                if "link" in doaj_api_response[index]["bibjson"].keys() and len(doaj_api_response[index]["bibjson"]["link"]) > 0 and "url" in doaj_api_response[index]["bibjson"]["link"][0].keys():
                    self.assertEquals(result['url'], doaj_api_response[index]["bibjson"]["link"][0]["url"])
                else:
                    self.assertEquals(result['url'], "NO URL")
                
                if "author" in doaj_api_response[index]["bibjson"].keys():
                    self.assertGreater(len(result['authors']), 0)
                    for i, author in enumerate(result['authors']):
                        self.assertEquals(author, doaj_api_response[index]["bibjson"]["author"][i]["name"])
                else:
                    self.assertEquals(result['authors'], [])
            else:
                self.assertEquals(result['abstract'], "NO ABSTRACT")
                self.assertEquals(result['title'], "NO TITLE")
                self.assertEquals(result['url'], "NO URL")
                self.assertEquals(result['authors'], [])


# tests for the GET API which uses CORE API
class core_api_test_cases(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('Tests for GET requests using CORE API completed!')

    @skip('this test works in local but fails in GA')
    def test_unexpected_responses(self):
        # missing title case
        temp = self.c.get("/api/core")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing title param with url '/api/core'.")
        self.assertEquals(json.loads(temp.content.decode("UTF-8")),
                          {'status': "'title' title param is required!"}, "Test failed: content test for missing title param with url '/api/core'.")

        # missing title case with rows
        temp = self.c.get("/api/core?rows=5")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing title param with url '/api/core?rows=5'.")
        self.assertEquals(json.loads(temp.content.decode("UTF-8")),
                          {'status': "'title' title param is required!"}, "Test failed: content test for missing title param with url '/api/core?rows=5'.")

        # missing title case with some random params
        temp = self.c.get("/api/core?randomNonexistParam=randomVal")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for missing title param with url '/api/core?randomNonexistParam=randomVal'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "'title' title param is required!"}, "Test failed: content test for missing title param with url '/api/core?randomNonexistParam=randomVal'.")

        # invalid rows case
        temp = self.c.get("/api/core?title=vision%20transformers&rows=abc")
        self.assertEquals(
            temp.status_code, 400, "Test failed: status_code test for invalid rows param with url '/api/core?title=vision%20transformers&rows=abc'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "'rows' rows param must be numeric if exist!"}, "Test failed: content test for invalid rows param with url '/api/core?title=vision%20transformers&rows=abc'.")

        # title not found case
        temp = self.c.get("/api/core?title=sdfhgaskdfgajksdhgf")
        self.assertEquals(
            temp.status_code, 404, "Test failed: status_code test for title not-found with url '/api/core?title=sdfhgaskdfgajksdhgf'.")
        self.assertEquals(json.loads(temp.content.decode(
            "UTF-8")), {'status': "There is no such content with the specified title on this source!"}, "Test failed: content test for title not-found with url '/api/core?title=sdfhgaskdfgajksdhgf'.")
    @skip('this test works in local but fails in GA')
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
        self.assertEqual(len(response.json()['results'][0]), field_count)
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
        self.assertEqual(len(response.json()['results'][0]), field_count)
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
        
        semantic_scholar_api_response = requests.get('https://api.semanticscholar.org/graph/v1/paper/search?query=covid&fields=title,authors,url&offset=0&limit=3')
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
            # self.assertEquals(semantic_scholar_api_response[count]['title'],result['title']) # This API usually returns different results for same query
            # self.assertEquals(semantic_scholar_api_response[count]['url'], result['url']) # This API usually returns different results for same query
            self.assertEquals(count, result['position'])

class orcid_api_test_cases(TestCase):

    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('Tests for GET requests using ORCID API completed!')

    def test_404_responses(self):
        self.assertEquals(self.c.get("/api/orcid-api/").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid-api/?").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid-api/?user_id=").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid-api/?user=").status_code, 404)

    def test_invalid_orcid_id(self):
        self.assertEquals(self.c.get("/api/orcid-api/?user_id=123456789").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid-api/?user_id=12-345-67-89").status_code, 404)

    def test_valid_orcid_id(self):
        response = self.c.get("/api/orcid-api/?user_id=0009-0005-5924-1831")
        self.assertEquals(response.status_code, 200)
        self.assertContains(response, "user_id")
        self.assertContains(response, "name")
        self.assertContains(response, "surname")
    
    def test_compare_results(self):
        response = self.c.get("/api/orcid-api/?user_id=0009-0005-5924-1831")

        Headers = {"Accept": "application/json"}
        orcid_api_response = requests.get("https://orcid.org/0009-0005-5924-1831", headers=Headers).json()
        response = response.json()
        self.assertEquals(response["name"], orcid_api_response["person"]["name"]["given-names"]["value"])
        self.assertEquals(response["user_id"], "0009-0005-5924-1831")
        if orcid_api_response["person"]["name"]["family-name"] != None:
            self.assertEquals(response["surname"], orcid_api_response["person"]["name"]["family-name"]["value"])
        else:
            self.assertEquals(response["surname"], None)

class registration_test_cases(TestCase):

    def setUp(self):
        self.c = Client()
        User.objects.create_user(username="0009-0005-5924-0000", password="strongpassword", first_name = "firstname", last_name = "lastname" )

    def tearDown(self):
        print('Tests for POST requests using user_registration completed!')

    def test_404_responses(self):
        self.assertEquals(self.c.post("/api/user-registration/", headers = {'username':'','password':'password'}).status_code, 404)
        self.assertEquals(self.c.post("/api/user-registration/", headers = {'username':'','password':''}).status_code, 404)
        self.assertEquals(self.c.post("/api/user-registration/", headers = {'username':'username','password':''}).status_code, 404)


    def test_unique_username(self):
        Header = {'username': '0009-0005-5924-1831', 'password': 'mypassword'}
        Json = {'name': 'Nicola', 'surname': 'Tesla'}

        response = self.c.post("/api/user-registration/", headers = Header)
        self.assertEquals(response.status_code, 200)
        self.assertEquals(len(User.objects.filter(username= "0009-0005-5924-1831")), 1)

    def test_invalid_username(self):
        Header = {'username': '0009-0005-5924-0000', 'password': 'mypassword'}
        Json = {'name': 'Nicola', 'surname': 'Tesla'}

        response = self.c.post("/api/user-registration/", headers = Header)
        self.assertEquals(response.status_code, 404)
        self.assertEquals(len(User.objects.filter(username= "0009-0005-5924-0000")), 1)



class log_in_test_cases(TestCase):

    def setUp(self):
        self.c = Client()
        User.objects.create_user(username="0009-0005-5924-1831", password="strongpassword", first_name = "firstname", last_name = "lastname" )

    def tearDown(self):
        print('Tests for POST requests using log_in completed!')

    def test_404_responses(self):
        self.assertEquals(self.c.post("/api/log-in/",headers={'username': '','password':''}).status_code, 404)
        self.assertEquals(self.c.post("/api/log-in/",headers = {'username':'username','password':''}).status_code, 404)
    
    def test_valid_login(self):
        Headers = {'username': "0009-0005-5924-1831", "password": "strongpassword"}
        response = self.c.post("/api/log-in/",headers = Headers)
        self.assertEquals(response.status_code, 200)
    
    def test_invalid_login(self):
        Headers = {'username': "0000-0002-0753-0000", "password": "strong"}
        self.assertEquals(self.c.post("/api/log-in/", headers = Headers).status_code, 404)
        Headers = {'username': "0000-0002-0753-1111", "password": "strong"}
        self.assertEquals(self.c.post("/api/log-in/", headers = Headers).status_code, 404)

class log_out_test_cases(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('Tests for GET requests using log_out completed!')

    def test_logout(self):
        self.assertEquals(self.c.get("/api/log-out/").status_code, 200)

class SavePaperListTest(TestCase):

    def setUp(self):

        #Setting up a test user object and a test paper list object

        self.client = Client()
        self.user = User.objects.create_user(
            username='testuser', password='testpass'
        )
        self.paper_list = models.PaperList.objects.create(
            id = 1,
            list_title='Test Paper List',
            owner = self.user
        )

    def tearDown(self):
        print('Tests for POST requests using save_paper_list completed!')

    def test_save_paper_list_authenticated(self):
        # Testing for the successful case with a valid paper list id and valid credentials
        url = '/api/save-paper-list/'
        headers = {
            'HTTP_USERNAME': 'testuser',
            'HTTP_PASSWORD': 'testpass',
        }
        response = self.client.post(url, {'paper_list_id': self.paper_list.id}, **headers)

        self.assertEqual(response.status_code, 200)
        self.paper_list.refresh_from_db()
        self.assertIn(self.user, self.paper_list.saver.all())
        self.assertEqual(
            response.json()['status'], 
            'Paper list is saved successfully!'
        )

    def test_save_paper_list_unauthenticated(self):
        # Testing for the case where the user credentials are not filled
        url = '/api/save-paper-list/'
        response = self.client.post(url, {'paper_list_id': self.paper_list.id})

        self.assertEqual(response.status_code, 407)
        self.assertEqual(
            response.json()['status'],
            'Empty username or password!'
        )

    def test_save_paper_list_invalid_credentials(self):
        # Testing for the case where the user credentials are not correct
        url = '/api/save-paper-list/'
        headers = {
            'HTTP_USERNAME': 'testuser',
            'HTTP_PASSWORD': 'incorrectpassword',
        }
        response = self.client.post(url, {'paper_list_id': self.paper_list.id}, **headers)

        self.assertEqual(response.status_code, 401)
        self.assertEqual(
            response.json()['status'],
            'Incorrect username or password!'
        )

    def test_save_paper_list_not_found(self):
        # Testing for the case where the provided paper list id is not valid
        url = '/api/save-paper-list/'
        headers = {
            'HTTP_USERNAME': 'testuser',
            'HTTP_PASSWORD': 'testpass',
        }
        response = self.client.post(url, {'paper_list_id': 99}, **headers)

        self.assertEqual(response.status_code, 404)
        self.assertEqual(
            response.json()['status'],
            'Paper list is not found!'
        )

        response = self.client.post(url, {'paper_list_id': ''}, **headers)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(
            response.json()['status'],
            'Paper list is not found!'
        )

        response = self.client.post(url, {'paper_list_id': 'asdfg'}, **headers)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(
            response.json()['status'],
            'Paper list is not found!'
        )
        
        response = self.client.post(url, None, **headers)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(
            response.json()['status'],
            'Paper list id must be provided!'
        )

class FollowUserTestCase(TestCase):
    def setUp(self):
        self.c = Client()
        user_1 = User.objects.create_user(username="0009-0005-5924-1831", password="strongpassword", first_name = "follower", last_name = "follower")
        user_2 = User.objects.create_user(username="0009-0005-5924-1832", password="strongpassword", first_name = "followed_pending", last_name = "followed_pending")
        user_3 = User.objects.create_user(username="0009-0005-5924-1833", password="strongpassword", first_name = "followed_approved", last_name = "followed_approved")
        user_1_follower = models.Follower.objects.create(user=user_1)
        user_1_follower.followed.add(user_3)
        user_3_follower = models.Follower.objects.create(user=user_3)
        user_3_follower.follower.add(user_1)

    def tearDown(self):
        print('Tests for POST requests using follow_user completed!')
    
    def test_unauthorized_follower(self):
        # no headers are provided
        response = self.c.post("/api/follow-user/")
        self.assertEquals(response.status_code, 407)
        self.assertEquals(response.json()['status'], "username and password fields can not be empty")

        # empty credentials are provided
        response = self.c.post("/api/follow-user/", headers = {'username':'','password':''})
        self.assertEquals(response.status_code, 401)
        self.assertEquals(response.json()['status'], "user credentials are incorrect.")

        # invalid follower is provided
        response = self.c.post("/api/follow-user/", headers = {'username':'dummy','password':'dummy'})
        self.assertEquals(response.status_code, 401)
        self.assertEquals(response.json()['status'], "user credentials are incorrect.")

    def test_invalid_followed_username(self):
        Headers = {'username': "0009-0005-5924-1831", "password": "strongpassword"}

        # no followed username is provided
        response = self.c.post("/api/follow-user/", headers = Headers)
        
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()['status'], "Username of followed should be provided.")

        # empty followed username is provided
        response = self.c.post("/api/follow-user/", headers = Headers, data = {'followed_username':''})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()['status'], "Username of followed should be provided.")

        # followed is not a valid username
        response = self.c.post("/api/follow-user/", headers = Headers, data = {'followed_username':'dummy'})
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json()['status'], "Username of followed is invalid.")

    def test_valid_and_invalid_follow_cases(self):
        # follow request is sent for the first time
        Headers = {'username': "0009-0005-5924-1831", "password": "strongpassword"}
        Body = {'followed_username':'0009-0005-5924-1832'}
        response = self.c.post("/api/follow-user/", headers = Headers, data = Body)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['status'], "User followed.")

        # follow request is sent for the second time
        response = self.c.post("/api/follow-user/", headers = Headers, data = Body)
        self.assertEqual(response.status_code, 409)
        self.assertEqual(response.json()['status'], "You have already sent a following request this user.")

    def test_already_follower_cases(self):
        # follower_user is already following followed_user
        Headers = {'username': "0009-0005-5924-1831", "password": "strongpassword"}
        Body = {'followed_username':'0009-0005-5924-1833'}
        response = self.c.post("/api/follow-user/", headers = Headers, data = Body)
        self.assertEqual(response.status_code, 409)
        self.assertEqual(response.json()['status'], "You are already following this user.")

class post_paper_test_cases(TestCase):
    def setUp(self):
        self.client = Client()
        User.objects.create_user(username="0009-0005-5924-0000", password="strongpassword", first_name="firstname", last_name="lastname")

    def tearDown(self):
        print('Tests for POST method post-papers completed!')

    def test_post(self):
        response = self.client.post("/api/post-papers/",{'db':'zenodo','title' : 'sad', 'rows' : 5 },headers={'username':"0009-0005-5924-0000",'password':'strongpassword'})
        self.assertEquals(response.status_code,200)
        self.assertEquals(len(models.Paper.objects.filter(source='Zenodo')),5)
        response = self.client.post("/api/post-papers/", {'db': 'semantic-scholar', 'title': 'sad', 'rows': 5},
                                    headers={'username': "0009-0005-5924-0000", 'password': 'strongpassword'})
        self.assertEquals(response.status_code, 200)
        self.assertEquals(len(models.Paper.objects.filter(source='semantic_scholar')), 5)
        response = self.client.post("/api/post-papers/", {'db': 'google-scholar', 'title': 'sad', 'rows': 6},
                                            headers={'username': "0009-0005-5924-0000", 'password': 'strongpassword'})
        self.assertEquals(response.status_code, 200)
        self.assertEquals(len(models.Paper.objects.filter(source='google_scholar')), 6)
        response = self.client.post("/api/post-papers/", {'db': 'doaj', 'title': 'sad', 'rows': 8},
                                    headers={'username': "0009-0005-5924-0000", 'password': 'strongpassword'})
        self.assertEquals(response.status_code, 200)
        self.assertEquals(len(models.Paper.objects.filter(source='DOAJ')), 8)
        # response = self.client.post("/api/post-papers/", {'db': 'core', 'title': 'sad', 'rows': 3},
        #                             headers={'username': "0009-0005-5924-0000", 'password': 'strongpassword'})
        # self.assertEquals(response.status_code, 200)
        # self.assertEquals(len(models.Paper.objects.filter(source='core.ac.uk')), 3)
        response = self.client.post("/api/post-papers/", {'db': 'eric', 'title': 'sad'},
                                    headers={'username': "0009-0005-5924-0000", 'password': 'strongpassword'})
        self.assertEquals(response.status_code, 200)
        self.assertEquals(len(models.Paper.objects.filter(source='eric-api')), 3)

    def test_4xx_responses(self):
        response = self.client.post("/api/post-papers/", {'title': 'sad', 'rows': 3},
                                    headers={'username': "0009-0005-5924-0000", 'password': 'strongpassword'})
        self.assertEquals(response.status_code,400)
        self.assertEquals(json.loads(response.content.decode("UTF-8")),{'status': 'db and title parameters must be added to the request body.'})

        response = self.client.post("/api/post-papers/",{'db':'zenodo', 'rows' : 3 },headers={'username':"0009-0005-5924-0000",'password':'strongpassword'})
        self.assertEquals(response.status_code,400)
        self.assertEquals(json.loads(response.content.decode("UTF-8")), {'status': 'db and title parameters must be added to the request body.'})

        response = self.client.post("/api/post-papers/",{'db':'zenodo','title' : 'sad', 'rows' : 3 },headers={'username':"0009-0005-5924-0000"})
        self.assertEquals(response.status_code, 407)
        self.assertEquals(json.loads(response.content.decode("UTF-8")),{'status': 'username and password fields can not be empty'})

        response = self.client.post("/api/post-papers/", {'db': 'zenodo', 'title': '', 'rows': 3},
                                    headers={ 'password': 'strongpassword'})
        self.assertEquals(response.status_code, 407)
        self.assertEquals(json.loads(response.content.decode("UTF-8")),{'status': 'username and password fields can not be empty'})

        response = self.client.post("/api/post-papers/", {'db': 'zenodo', 'title': 'sad', 'rows': 5},
                                    headers={'username': "0009-0005-5924-000", 'password': 'strongpassword'})
        self.assertEquals(response.status_code,401)
        self.assertEquals(json.loads(response.content.decode("UTF-8")), {'status' : 'user credentials are incorrect.'})


class Add_Paper_To_List_Test_Cases(TestCase):
    def setUp(self):
        self.c = Client()
        User.objects.create_user(username="1234-5678-9012-3456", password="strongpassword", first_name="namefirst", last_name="namelast")

    def tearDown(self):
        print('POST Method to Add a Paper to a List Has Been Completed Successfully')

    def test_add_paper_to_list(self):
        user = User.objects.filter(username="1234-5678-9012-3456")[0]
        paper_list = models.PaperList.objects.create(list_title="Test List", owner=user)
        paper1 = models.Paper.objects.create(third_party_id="1", source="Source", abstract="Abstract1", year=2001, title="Title1")
        paper2 = models.Paper.objects.create(third_party_id="12", source="SourceSource", abstract="Abstract2", year=2002, title="Title2")
        paper3 = models.Paper.objects.create(third_party_id="123", source="SourceSourceSource", abstract="Abstract3", year=2003, title="Title3")
        paper4 = models.Paper.objects.create(third_party_id="1234", source="SourceSourceSourceSource", abstract="Abstract4", year=2004, title="Title4")
       

        headers = {'HTTP_USERNAME': "1234-5678-9012-3456", 'HTTP_PASSWORD': "strongpassword"}
        response = self.client.post("/api/add-paper-to-list/", data={'list_id': paper_list.id,'paper_id' : paper1.paper_id}, **headers)
        response = self.client.post("/api/add-paper-to-list/", data={'list_id': paper_list.id,'paper_id' : paper2.paper_id}, **headers)
        response = self.client.post("/api/add-paper-to-list/", data={'list_id': paper_list.id,'paper_id' : paper3.paper_id}, **headers)
        response = self.client.post("/api/add-paper-to-list/", data={'list_id': paper_list.id,'paper_id' : paper4.paper_id}, **headers)

        self.assertEquals(response.status_code, 200)
        p_list = models.PaperList.objects.filter(id=paper_list.id)[0]
        self.assertTrue(paper1 in p_list.paper.all() and paper2 in p_list.paper.all() and paper3 in p_list.paper.all() and paper4 in p_list.paper.all())


class pubchem_api_test_cases(TestCase):
    def setUp(self):
        self.client = Client()

    def tearDown(self):
        print('Tests for Pubchem API completed!')

    def test_empty_compount_id(self):
        response = self.client.post("/api/pubchem-api/", data={'compound_id': ''})
        self.assertEquals(response.status_code, 400)
        self.assertEquals(response.json()['status'], "Compound ID can't be empty")

    def test_invalid_compount_id(self):
        response = self.client.post("/api/pubchem-api/", data={'compound_id': 'dummy'})
        self.assertEquals(response.status_code, 404)
        self.assertEquals(response.json()['status'], "There isn't any compounds with the requested compound ID")

    def test_valid_compount_id(self):
        response = self.client.post("/api/pubchem-api/", data={'compound_id': '1'})
        print(response)
        self.assertEquals(response.status_code, 200)
        self.assertEquals(response.json()['status'], "Compound found")


class accept_follow_request_test_cases(TestCase):
    def setUp(self):
        self.c = Client()
        user_1 = User.objects.create_user(username="0009-0005-5924-2031", password="strongpassword", first_name = "user", last_name = "1")
        user_2 = User.objects.create_user(username="0009-0005-5924-2032", password="strongpassword", first_name = "user", last_name = "2")
        user_3 = User.objects.create_user(username="0009-0005-5924-2033", password="strongpassword", first_name = "followed", last_name = "3")
        request1 = models.FollowRequest.objects.create(sender=user_1, receiver=user_2, status='pending')
        request2 = models.FollowRequest.objects.create(sender=user_1, receiver=user_3, status='rejected')

    def tearDown(self):
        print('Tests for POST requests using accept_follow_request completed!')

    def test_unauthorized_receiver(self):
        # no headers are provided
        response = self.c.post("/api/accept-follow-request/")
        self.assertEquals(response.status_code, 407)
        self.assertEquals(response.json()['status'], "username and password fields can not be empty")

        # empty credentials are provided
        response = self.c.post("/api/accept-follow-request/", headers = {'username':'','password':''})
        self.assertEquals(response.status_code, 401)
        self.assertEquals(response.json()['status'], "user credentials are incorrect.")

        # invalid receiver is provided
        response = self.c.post("/api/accept-follow-request/", headers = {'username':'dummy','password':'dummy'})
        self.assertEquals(response.status_code, 401)
        self.assertEquals(response.json()['status'], "user credentials are incorrect.")

    def test_nonexisting_follow_request(self):
        Headers = {'username': "0009-0005-5924-2032", "password": "strongpassword"}

        # wrong sender or receiver provided
        response = self.c.post("/api/accept-follow-request/", headers=Headers, data={'sender_id': 'dummy', 'receiver_id': 'dummy'})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()['status'], "User/users not found")

    def test_answered_follow_request(self):
        Headers = {'username': "0009-0005-5924-2033", "password": "strongpassword"}

        # an already answered follow request is provided
        response = self.c.post("/api/accept-follow-request/", headers=Headers, data={'sender_id': '0009-0005-5924-2031', 'receiver_id': '0009-0005-5924-2033'})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()['status'], "Follow request is already answered")

    def test_unanswered_follow_request(self):
        Headers = {'username': "0009-0005-5924-2033", "password": "strongpassword"}

        # an already answered follow request is provided
        response = self.c.post("/api/accept-follow-request/", headers=Headers, data={'sender_id': '0009-0005-5924-2031', 'receiver_id': '0009-0005-5924-2032'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['status'], "Follow request accepted")


class reject_follow_request_test_cases(TestCase):
    def setUp(self):
        self.c = Client()
        user_1 = User.objects.create_user(username="0009-0005-5924-2031", password="strongpassword", first_name="user",
                                          last_name="1")
        user_2 = User.objects.create_user(username="0009-0005-5924-2032", password="strongpassword", first_name="user",
                                          last_name="2")
        user_3 = User.objects.create_user(username="0009-0005-5924-2033", password="strongpassword",
                                          first_name="followed", last_name="3")
        request1 = models.FollowRequest.objects.create(sender=user_1, receiver=user_2, status='pending')
        request2 = models.FollowRequest.objects.create(sender=user_1, receiver=user_3, status='accepted')

    def tearDown(self):
        print('Tests for POST requests using reject_follow_request completed!')

    def test_unauthorized_receiver(self):
        # no headers are provided
        response = self.c.post("/api/reject-follow-request/")
        self.assertEquals(response.status_code, 407)
        self.assertEquals(response.json()['status'], "username and password fields can not be empty")

        # invalid follower is provided
        response = self.c.post("/api/reject-follow-request/", headers={'username': 'dummy', 'password': 'dummy'})
        self.assertEquals(response.status_code, 401)
        self.assertEquals(response.json()['status'], "user credentials are incorrect.")

    def test_nonexisting_follow_request(self):
        Headers = {'username': "0009-0005-5924-2032", "password": "strongpassword"}

        # wrong sender or receiver provided
        response = self.c.post("/api/reject-follow-request/", headers=Headers,
                               data={'sender_id': 'dummy', 'receiver_id': 'dummy'})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()['status'], "User/users not found")

    def test_answered_follow_request(self):
        Headers = {'username': "0009-0005-5924-2033", "password": "strongpassword"}

        # an already answered follow request is provided
        response = self.c.post("/api/reject-follow-request/", headers=Headers,
                               data={'sender_id': '0009-0005-5924-2031', 'receiver_id': '0009-0005-5924-2033'})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()['status'], "Follow request is already answered")

    def test_unanswered_follow_request(self):
        Headers = {'username': "0009-0005-5924-2033", "password": "strongpassword"}

        # an already answered follow request is provided
        response = self.c.post("/api/reject-follow-request/", headers=Headers,
                               data={'sender_id': '0009-0005-5924-2031', 'receiver_id': '0009-0005-5924-2032'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['status'], "Follow request rejected")
