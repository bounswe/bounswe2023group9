from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from database.serializers import RegisterSerializer, UserSerializer
from database import models
# Create your tests here.


class SignUpAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.signup_url = reverse("signup")

    def tearDown(self):
        User.objects.all().delete()
        print('All tests for the Sign Up API are completed!')

    def test_user_signup(self):
        # Testing the POST method for signing up
        data = {
            "username": "testuser",
            "password": "testpassword",
            "password2": "testpassword",
            "email": "test@example.com",
            "first_name": "User",
            "last_name": "Test",
        }

        response = self.client.post(self.signup_url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


class UserDetailAPITestCase(TestCase):

    def setUp(self):

        self.client = APIClient()
        self.user = User.objects.create_user(id=1, email= 'test@example.com', username='testuser', first_name='User', last_name='Test')
        self.token = Token.objects.create(user=self.user)
        self.get_user_detail_url = reverse("get_authenticated_user")

    def tearDown(self):
        User.objects.all().delete()
        print("All tests for the User Detail API are completed!")

    def test_get_user_detail_authenticated(self):
        # Testing the GET method for getting authenticated user details
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.token.key}")
        response = self.client.get(self.get_user_detail_url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['id'], self.user.id)
        self.assertEqual(response.data['email'], self.user.email)
        # self.assertEqual(response.data['username'], self.user.username)
        self.assertEqual(response.data['first_name'], self.user.first_name)
        self.assertEqual(response.data['last_name'], self.user.last_name)

    def test_get_user_detail_not_authenticated(self):
        # Testing the GET method for getting not authenticated user details
        response = self.client.get(self.get_user_detail_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

class SearchAPITestCase(TestCase):
    def setUp(self):

        self.client = APIClient()
        user = User.objects.create_user(id=1, email='test@example.com', username='test@example.com', first_name='User',
                                        last_name='Test')
        # basic_user = BasicUser.objects.create(user=user, bio='Hello')
        cont = models.Contributor.objects.create(user=user, bio='Hello')
        node = models.Node.objects.create(node_title='test',
                                   theorem=None,
                                   publish_date="2023-01-01",
                                   is_valid=True,
                                   num_visits=0, )
        node.contributors.add(cont)
        self.search_url = reverse("search")

    def tearDown(self):
        User.objects.all().delete()

    def test_search(self):
        data = {'query':'search'}
        response = self.client.get(self.search_url,data,format='json')
        self.assertEqual(response.status_code,400)
        data = {'type': 'author'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 400)
        data = {'query': 'test','type':'node'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['nodes'][0]['id'], 1)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')
        self.assertEqual(response.json()['authors'], [])
        data = {'query': 'test', 'type': 'author'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['nodes'], [])
        self.assertEqual(response.json()['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['authors'][0]['username'], 'test@example.com')
        data = {'query': 'test', 'type': 'by'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['nodes'][0]['id'], 1)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')
        data = {'query': 'test', 'type': 'all'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['authors'][0]['username'], 'test@example.com')
        self.assertEqual(response.json()['nodes'][0]['id'], 1)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')
