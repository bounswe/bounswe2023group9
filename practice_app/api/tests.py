from django.test import TestCase,Client
from unittest import skip
import requests
from django.contrib.auth.models import User

# Create your tests here.

class orcid_api_test_cases(TestCase):

    def setUp(self):
        self.c = Client()

    def test_404_responses(self):
        self.assertEquals(self.c.get("/api/orcid_api/").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid_api/?").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid_api/?user_id=").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid_api/?user=").status_code, 404)

    def test_invalid_orcid_id(self):
        self.assertEquals(self.c.get("/api/orcid_api/?user_id=123456789").status_code, 404)
        self.assertEquals(self.c.get("/api/orcid_api/?user_id=12-345-67-89").status_code, 404)

    def test_valid_orcid_id(self):
        response = self.c.get("/api/orcid_api/?user_id=0009-0005-5924-1831")
        self.assertEquals(response.status_code, 200)
        self.assertContains(response, "user_id")
        self.assertContains(response, "name")
        self.assertContains(response, "surname")
    
    def test_compare_results(self):
        response = self.c.get("/api/orcid_api/?user_id=0009-0005-5924-1831")

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

    def test_404_responses(self):
        self.assertEquals(self.c.get("/api/user_registration/").status_code, 404)
        self.assertEquals(self.c.get("/api/user_registration/?user_id=0009-0005-5924-1831").status_code, 404)
        self.assertEquals(self.c.get("/api/user_registration/?user_id=0009-0005-5924-1831&?").status_code, 404)
        self.assertEquals(self.c.get("/api/user_registration/?user_id=0009-0005-5924-1831&password=mypassword&").status_code, 404)
        self.assertEquals(self.c.get("/api/user_registration/?user_id=0009-0005-5924-1831&password=mypassword&surname=Tesla").status_code, 404)

    def test_unique_username(self):
        response = self.c.get("/api/user_registration/?user_id=0009-0005-5924-1831&password=mypassword&name=Nicola&surname=Tesla")
        self.assertEquals(response.status_code, 200)
        self.assertEquals(len(User.objects.filter(username= "0009-0005-5924-1831")), 1)

    def test_invalid_username(self):
        response = self.c.get("/api/user_registration/?user_id=0009-0005-5924-0000&password=mypassword&name=Nicola&surname=Tesla")
        self.assertEquals(response.status_code, 404)
        self.assertEquals(len(User.objects.filter(username= "0009-0005-5924-0000")), 1)

class log_in_test_cases(TestCase):

    def setUp(self):
        self.c = Client()
        User.objects.create_user(username="0009-0005-5924-0000", password="strongpassword", first_name = "firstname", last_name = "lastname" )

    def test_404_responses(self):
        self.assertEquals(self.c.get("/api/log_in/").status_code, 404)
        self.assertEquals(self.c.get("/api/log_in/?").status_code, 404)
        self.assertEquals(self.c.get("/api/log_in/?username=").status_code, 404)
        self.assertEquals(self.c.get("/api/log_in/?password=").status_code, 404)
        self.assertEquals(self.c.get("/api/log_in/?username=someone").status_code, 404)
    
    def test_valid_login(self):
        response = self.c.get("/api/log_in/?username=0009-0005-5924-0000&password=strongpassword")
        self.assertEquals(response.status_code, 200)
    
    def test_invalid_login(self):
        self.assertEquals(self.c.get("/api/log_in/?username=0009-0005-5924-1212&password=strongpassword").status_code, 404)
        self.assertEquals(self.c.get("/api/log_in/?username=0009-0005-5924-0000&password=strong").status_code, 404)

class log_out_test_cases(TestCase):
    def setUp(self):
        self.c = Client()

    def test_logout(self):
        self.assertEquals(self.c.get("/api/log_out/").status_code, 200)