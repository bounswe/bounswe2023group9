from django.test import TestCase,Client
import requests

class DOAJ_API_Tester(TestCase):
    def setUp(self):
        self.c = Client()

    def tearDown(self):
        print('GET Tests Completed Successfully')

    def test_doaj_api(self):
        doaj_api_response = requests.get('https://doaj.org/api/search/articles/einstein,relativity?page=1&pageSize=3')
        self.assertEquals(doaj_api_response.status_code, 200, "DoajApi didn't work as supposed to")
        doaj_api_response = doaj_api_response.json()['results']
        
        response = self.c.get("/api/doaj-api/?query=einstein,relativity&row=3")
        self.assertEquals(response.status_code, 200)
        response_dict = response.json()
        self.assertIn('status_code',response_dict.keys())
        self.assertIn('count', response_dict.keys())
        count = 0
        for result in response_dict['results']:
            self.assertIn('id', result.keys())
            self.assertIn('source', result.keys())
            self.assertIn('authors',result.keys())
            self.assertIn('date', result.keys())
            self.assertIn('abstract', result.keys())
            self.assertIn('url', result.keys())
            self.assertIn('title',result.keys())
            self.assertEquals(result[count]['id'], doaj_api_response["id"])
            self.assertEquals(result['source'], 'DOAJ')
            self.assertEquals(result[count]['date'], doaj_api_response["created_date"])
            self.assertEquals(result[count]['abstract'], doaj_api_response["bibjson"]["abstract"])
            self.assertEquals(result[count]['title'], doaj_api_response["bibjson"]["title"])
            self.assertEquals(result[count]['url'], doaj_api_response["bibjson"]["link"][0]["url"])
            count += 1
