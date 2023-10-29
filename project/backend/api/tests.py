from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from django.contrib.auth.models import User
from database.models import BasicUser,Contributor,Node,Question, Proof, Theorem
from rest_framework.authtoken.models import Token
from database.serializers import RegisterSerializer, UserSerializer
from database import models
import datetime
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

class ChangePasswordAPITestCase(TestCase):

    def setUp(self):

        self.client = APIClient()
        self.user = User.objects.create_user(id=1, email= 'test@example.com', username='testuser', first_name='User', last_name='Test')
        self.user.set_password("correct_old_password")
        self.user.save()
        self.token = Token.objects.create(user=self.user)
        self.change_password_url = reverse("change_password")

    def tearDown(self):
        User.objects.all().delete()
        print("All tests for the Change Password API are completed!")
    
    def test_wrong_old_password(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.token.key}")

        data = {
            "old_password": "wrong_old_password",
            "password": "new_password"
        }

        response = self.client.put(self.change_password_url, data)

        self.assertEqual(response.status_code, 400)

    def test_success(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.token.key}")

        data = {
            "old_password": "correct_old_password",
            "password": "new_password"
        }

        response = self.client.put(self.change_password_url, data)

        self.assertEqual(response.status_code, 200)

class ChangeProfileSettingsAPITestCase(TestCase):
    def setUp(self):

        self.client = APIClient()
        self.user = User.objects.create_user(id=1, email= 'test@example.com', username='testuser', first_name='User', last_name='Test')
        self.basic_user = BasicUser.objects.create(user=self.user, bio="OLD BIO")
        self.token = Token.objects.create(user=self.user)
        self.change_password_url = reverse("change_profile_settings")

    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        print("All tests for the Change Profile Settings API are completed!")

    def test_success(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.token.key}")

        new_bio = "NEW BIO"
        new_email_pref = True
        new_activity_pref = False

        data = {
            "bio": new_bio,
            "email_notification_preference": new_email_pref,
            "show_activity_preference": new_activity_pref
        }

        response = self.client.put(self.change_password_url, data)

        basic_user = BasicUser.objects.get(id=self.basic_user.id)

        self.assertEqual(response.status_code, 200)
        self.assertEqual(basic_user.bio, new_bio)
        self.assertEqual(basic_user.email_notification_preference, new_email_pref)
        self.assertEqual(basic_user.show_activity_preference, new_activity_pref)

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
        # self.assertEqual(response.json()['nodes'][0]['id'], 1)
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
        # self.assertEqual(response.json()['nodes'][0]['id'], 1)
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
        # self.assertEqual(response.json()['nodes'][0]['id'], 1)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')


class ProfileGETAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        user = User.objects.create_user(id=1, email='test@example.com', username='test@example.com', first_name='User',
                                             last_name='Test')
        # basic_user = BasicUser.objects.create(user=user, bio='Hello')
        cont = Contributor.objects.create(user=user,bio='Hello')
        node = Node.objects.create(node_title='test',
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,)
        Q = Question.objects.create(
            node=node,
            asker = cont,
            question_content = "TEXT",
            answerer = cont
        )
        node.contributors.add(cont)
        self.get_profile_url = reverse('get_profile')
    def tearDown(self):
        Node.objects.all().delete()
        # Contributor.objects.all().delete()
        User.objects.all().delete()


    def test_get_user_profile(self):
        data = {'mail':'test@example.com'}
        response = self.client.get(self.get_profile_url, data, format="json")
        self.assertEqual(response.status_code,200)
        self.assertEqual(response.json()['name'],'User')
        self.assertEqual(response.json()['surname'], 'Test')
        self.assertEqual(response.json()['bio'], 'Hello')
        self.assertEqual(response.json()['nodes'][0]['id'],1)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')
        self.assertEqual(response.json()['answered_questions'][0],1)
        self.assertEqual(response.json()['asked_questions'][0], 1)

class ProofGETAPITestCase(TestCase):
    def setUp(self):
        # Create a sample Proof instance for testing
        self.sample_proof = Proof.objects.create(
            proof_id=0,
            proof_title="Sample Title",
            proof_content="Sample Content",
            is_valid=True,
            is_disproof=False,
            publish_date="2023-10-30",
            node_id = 0, 
        )
    def tearDown(self):
        Proof.objects.all().delete()
        print("All tests for the Proof GET API are completed!")

    def test_get_proof_from_id_valid(self):
        url = reverse('get_proof')  # Replace 'get_proof_from_id' with the actual URL name
        response = self.client.get(url, {'proof_id': 0})

        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(
            response.content.decode('utf-8'),
            {
                'proof_id': self.sample_proof.proof_id,
                'proof_title': self.sample_proof.proof_title,
                'proof_content': self.sample_proof.proof_content,
                'is_valid': self.sample_proof.is_valid,
                'is_disproof': self.sample_proof.is_disproof,
                'publish_date': '2023-10-30',
            }
        )

    def test_get_proof_from_id_not_found(self):
        url = reverse('get_proof')  # Replace 'get_proof_from_id' with the actual URL name
        response = self.client.get(url, {'proof_id': 999})  # Assuming an ID that doesn't exist

        self.assertEqual(response.status_code, 404)
        self.assertJSONEqual(
            response.content.decode('utf-8'),
            {'message': 'There is no proof with this id.'}
        )

class NodeAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.node_url = reverse("get_node")

        self.nodeA = Node.objects.create(
            node_id=1,
            node_title="Test Node A",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )

        Node.objects.create(
            node_id=2,
            node_title="Test Node B",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )

        Node.objects.create(
            node_id=3,
            node_title="Test Node C",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )

    def tearDown(self):
        Node.objects.all().delete()
        print("All tests for the Node API are completed!")

    def test_get_valid(self):
        data = {"node_id": "1"}
        response = self.client.get(self.node_url, data=data, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["node_id"], self.nodeA.node_id)
        self.assertEqual(response.data["node_title"], self.nodeA.node_title)
        self.assertEqual(response.data["is_valid"], self.nodeA.is_valid)
        self.assertEqual(response.data["num_visits"], self.nodeA.num_visits)

    def test_get_invalid(self):
        data = {"node_id": "-1"}
        response = self.client.get(self.node_url, data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_get_removed_node(self):
        Node.objects.create(
            node_id=4,
            node_title="Test Node Removed",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
            removed_by_admin=True,
        )

        data = {"node_id": "4"}
        response = self.client.get(self.node_url, data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

class TheoremGETAPITestCase(TestCase):
    def setUp(self):
        # Create a sample Theorem instance for testing
        self.sample_theorem = Theorem.objects.create(
            theorem_id=0,
            theorem_title="Sample Theorem Title",
            theorem_content="Sample Theorem Content",
            publish_date="2023-10-30",
        )

    def test_get_theorem_from_id_valid(self):
        url = reverse('get_theorem')  # Replace 'get_theorem_from_id' with the actual URL name
        response = self.client.get(url, {'theorem_id': 0})

        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(
            response.content.decode('utf-8'),
            {
                'theorem_id': self.sample_theorem.theorem_id,
                'theorem_title': self.sample_theorem.theorem_title,
                'theorem_content': self.sample_theorem.theorem_content,
                'publish_date': '2023-10-30',
            }
        )

    def test_get_theorem_from_id_not_found(self):
        url = reverse('get_theorem')  # Replace 'get_theorem_from_id' with the actual URL name
        response = self.client.get(url, {'theorem_id': 999})  # Assuming an ID that doesn't exist

        self.assertEqual(response.status_code, 404)
        self.assertJSONEqual(
            response.content.decode('utf-8'),
            {'message': 'There is no theorem with this id.'}
        )

