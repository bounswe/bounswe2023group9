from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from database.serializers import RegisterSerializer, UserSerializer
from database.models import *
import datetime

# Create your tests here for each class or API call.

class WorkspacePOSTAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()

        self.user_for_basic = User.objects.create_user(id=1, email= 'basic_user@example.com', username='basic_user@example.com', first_name='Basic User', last_name='Test1')
        self.user_for_contributor1 = User.objects.create_user(id=2, email= 'cont1@example.com', username='cont1@example.com', first_name='Contributor User 2', last_name='Test2')
        self.user_for_contributor2 = User.objects.create_user(id=3, email= 'cont2@example.com', username='cont2@example.com', first_name='Contributor User 3', last_name='Test3')

        self.basic_user = BasicUser.objects.create(user=self.user_for_basic, bio="I am a basic user")
        self.contributor1 = Contributor.objects.create(user=self.user_for_contributor1, bio="I am the first contributor")
        self.contributor2 = Contributor.objects.create(user=self.user_for_contributor2, bio="I am the second contributor")

        self.basic_user_token = Token.objects.create(user=self.user_for_basic)
        self.contributor1_token = Token.objects.create(user=self.user_for_contributor1)
        self.contributor2_token = Token.objects.create(user=self.user_for_contributor2)

        self.semantic_tag1 = SemanticTag.objects.create(wid="Q1", label="Semantic Tag 1")
        self.semantic_tag2 = SemanticTag.objects.create(wid="Q2", label="Semantic Tag 2")
    
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        Contributor.objects.all().delete()
        Token.objects.all().delete()
        Workspace.objects.all().delete()
        SemanticTag.objects.all().delete()

        print("All tests for the Workspace POST API are completed!")

    def test_create_workspace(self):
        # Testing the POST method for basic user tries to create workspace
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.basic_user_token.key}")
        data = {
            "workspace_title": "Basic User Workspace",
            "semantic_tags": [self.semantic_tag1.pk]
            }

        response = self.client.post(reverse("workspace_post"), data, format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN, "Test failed: Basic user shouldnot be able to create a workspace")

        # Testing the POST method for creating without title
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.contributor1_token.key}")

        data = {
            "semantic_tags": [self.semantic_tag1.pk]
        }
        response = self.client.post(reverse("workspace_post"), data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST, "Test failed: Workspace cannot be created without a title")

        # Testing the POST method for creating without semantic tags
        data = {
            "workspace_title": "Contributor1 Workspace"
        }
        response = self.client.post(reverse("workspace_post"), data, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED, "Test failed: Workspace can be created without semantic tags")

        workspaces = self.contributor1.workspaces.all()
        self.assertEqual(workspaces.count(), 1, "Test failed: Workspace could not be created")

        # Testing the POST method for updating workspace
        if workspaces.count() > 0:
            workspace = workspaces[0]

            data = {
                "workspace_id": workspace.workspace_id,
                "workspace_title": "Contributor1 Workspace Updated",
                "semantic_tags": [self.semantic_tag2.pk]
            }
            response = self.client.post(reverse("workspace_post"), data, format="json")

            workspace = Workspace.objects.get(workspace_id=workspace.workspace_id)
            self.assertEqual(response.status_code, status.HTTP_201_CREATED, "Update failure")
            self.assertEqual(workspace.semantic_tags.count(), 1, "Update failure for semantic tags count")
            self.assertEqual(workspace.semantic_tags.all()[0].wid, self.semantic_tag2.wid, "Update failure for semantic tag")
            self.assertEqual(workspace.workspace_title, "Contributor1 Workspace Updated", "Update failure for title")

            # Try to update workspace of a different contributor
            self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.contributor2_token.key}")
            data = {
                "workspace_id": workspace.workspace_id,
                "workspace_title": "Contributor2 Workspace Updated",
                "semantic_tags": [self.semantic_tag1.pk]
            }
            response = self.client.post(reverse("workspace_post"), data, format="json")
            self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN, "Test failed: Contributor2 shouldnot be able to update Contributor1's workspace")


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
        cont = Contributor.objects.create(user=user, bio='Hello',id=1)
        node = Node.objects.create(node_title='test',
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
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['id'], 1)
        self.assertEqual(response.json()['authors'], [])
        data = {'query': 'test', 'type': 'author'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['nodes'], [])
        self.assertEqual(response.json()['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['authors'][0]['username'], 'test@example.com')
        self.assertEqual(response.json()['authors'][0]['id'], 1)
        data = {'query': 'test', 'type': 'by'}
        response = self.client.get(self.search_url, data, format='json')
        self.assertEqual(response.status_code, 200)
        # self.assertEqual(response.json()['nodes'][0]['id'], 1)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['id'], 1)
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
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['id'], 1)


class ProfileGETAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        user = User.objects.create_user(id=1, email='test@example.com', username='test@example.com', first_name='User',
                                             last_name='Test')
        # basic_user = BasicUser.objects.create(user=user, bio='Hello')
        cont = Contributor.objects.create(user=user,bio='Hello',id=1)
        node = Node.objects.create(node_title='test',
                                   node_id = 55,
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,)
        Q = Question.objects.create(
            node=node,
            asker = cont,
            question_content = "QUESTION",
            answerer = cont,
            answer_content = 'ANSWER',

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
        self.assertEqual(response.json()['nodes'][0]['id'],55)
        self.assertEqual(response.json()['nodes'][0]['title'], 'test')
        self.assertEqual(response.json()['nodes'][0]['date'], '2023-01-01')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['name'], 'User')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['surname'], 'Test')
        self.assertEqual(response.json()['nodes'][0]['authors'][0]['username'], 'test@example.com')
        # TODO TESTS FAIL HERE
        self.assertEqual(response.json()['answered_questions'][0]['question_content'],'QUESTION')
        self.assertEqual(response.json()['answered_questions'][0]['answer_content'],'ANSWER')
        self.assertEqual(response.json()['answered_questions'][0]['asker_name'], 'User')
        self.assertEqual(response.json()['answered_questions'][0]['asker_surname'], 'Test')
        self.assertEqual(response.json()['answered_questions'][0]['asker_id'], 1)
        self.assertEqual(response.json()['answered_questions'][0]['asker_mail'], 'test@example.com')
        self.assertEqual(response.json()['answered_questions'][0]['node_id'], 55)
        self.assertEqual(response.json()['answered_questions'][0]['node_title'], 'test')
        self.assertEqual(response.json()['answered_questions'][0]['answerer_name'], 'User')
        self.assertEqual(response.json()['answered_questions'][0]['answerer_surname'], 'Test')
        self.assertEqual(response.json()['answered_questions'][0]['answerer_id'], 1)
        self.assertEqual(response.json()['answered_questions'][0]['answerer_mail'], 'test@example.com')

        self.assertEqual(response.json()['asked_questions'][0]['question_content'], 'QUESTION')
        self.assertEqual(response.json()['asked_questions'][0]['answer_content'], 'ANSWER')
        self.assertEqual(response.json()['asked_questions'][0]['asker_name'], 'User')
        self.assertEqual(response.json()['asked_questions'][0]['asker_surname'], 'Test')
        self.assertEqual(response.json()['asked_questions'][0]['asker_id'], 1)
        self.assertEqual(response.json()['asked_questions'][0]['asker_mail'], 'test@example.com')
        self.assertEqual(response.json()['asked_questions'][0]['node_id'], 55)
        self.assertEqual(response.json()['asked_questions'][0]['node_title'], 'test')
        self.assertEqual(response.json()['asked_questions'][0]['answerer_name'], 'User')
        self.assertEqual(response.json()['asked_questions'][0]['answerer_surname'], 'Test')
        self.assertEqual(response.json()['asked_questions'][0]['answerer_id'], 1)
        self.assertEqual(response.json()['asked_questions'][0]['answerer_mail'], 'test@example.com')

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

    def test_get_random_node(self):
        response = self.client.get(self.node_url)
        
        self.assertEqual(response.status_code, 200)

        self.assertContains(response, 'node_id')
        self.assertContains(response, 'node_title')
        self.assertContains(response, 'publish_date')
        self.assertContains(response, 'is_valid')
        self.assertContains(response, 'num_visits')
        self.assertContains(response, 'theorem')
        self.assertContains(response, 'contributors')
        self.assertContains(response, 'reviewers')
        self.assertContains(response, 'from_referenced_nodes')
        self.assertContains(response, 'to_referenced_nodes')
        self.assertContains(response, 'proofs')
        self.assertContains(response, 'question_set')
        self.assertContains(response, 'semantic_tags')
        self.assertContains(response, 'annotations')
    def test_get_random_node_id(self):
        url = reverse('get_random_node_id')
        response = self.client.get(url , {'count':2})
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIn('node_ids', data)
        self.assertEqual(len(data['node_ids']), 2)

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



class ContributorGETAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(id=1, email='test@example.com', username='test@example.com', first_name='User',
                                        last_name='Test')
        self.cont = Contributor.objects.create(user=self.user, bio='Hello',id=3)
        self.url = reverse('get_cont')

    def test_get_contributor_from_id(self):
        response = self.client.get(self.url, {'id': 3})

        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(
            response.content.decode('utf-8'),
            {
                'id': self.cont.id,
                'name': self.user.first_name,
                'surname': self.user.last_name,
                'username': self.user.username,
            }
        )


class UserWorkspacesGETAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(id=1, email='test@example.com', username='test@example.com', first_name='User',
                                        last_name='Test')
        self.cont = Contributor.objects.create(user=self.user, bio='Hello',id=3)
        self.workspace = self.cont.create_workspace('test')
        self.url = reverse('get_user_workspaces')

    def test_get_workspaces_of_user(self):
        response = self.client.get(self.url, {'user_id': self.cont.id})

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['workspaces'][0]['workspace_id'],self.workspace.workspace_id)
        self.assertEqual(response.json()['workspaces'][0]['workspace_title'], self.workspace.workspace_title)
        self.assertEqual(response.json()['workspaces'][0]['pending'], False)



class WorkspaceGETAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(id=1, email='test@example.com', username='test@example.com', first_name='User',
                                        last_name='Test')
        self.cont = Contributor.objects.create(user=self.user, bio='Hello',id=3)
        self.workspace = self.cont.create_workspace('test')
        self.url = reverse('get_workspace')

    def test_get_workspace_from_id(self):
        response = self.client.get(self.url, {'workspace_id': self.workspace.workspace_id})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['workspace_id'],self.workspace.workspace_id)
        self.assertEqual(response.json()['workspace_id'], self.workspace.workspace_id)
        self.assertEqual(response.json()['contributors'], [{'id':self.cont.id,'first_name':self.user.first_name,'last_name':self.user.last_name,'username':self.user.username}])
        self.assertEqual(response.json()['workspace_title'], self.workspace.workspace_title)
        self.assertEqual(response.json()['status'], 'workable')
        self.assertEqual(response.json()['references'], [])
        self.assertEqual(response.json()['semantic_tags'], [])
        self.assertEqual(response.json()['pending_contributors'], [])
        self.assertEqual(response.json()['num_approvals'], 0)
        # self.assertEqual(response.json()['created_at'], self.workspace.created_at)


class CollaborationRequestAPITestCase(TestCase):

    def tearDown(self):
        Workspace.objects.all().delete()
        User.objects.all().delete()
        Contributor.objects.all().delete()
        CollaborationRequest.objects.all().delete()
        print("Test for the CollaborationRequest API is completed!")
        
    def setUp(self):
        self.client = APIClient()

        self.workspace = Workspace.objects.create()
        self.contributor_receiver = Contributor.objects.create(user=User.objects.create(username="receiver"))
        self.contributor_sender = Contributor.objects.create(user=User.objects.create(username="sender"))

        self.request = CollaborationRequest.objects.create(workspace=self.workspace,receiver=self.contributor_receiver,sender=self.contributor_sender)

        self.request_data = {
            'sender': self.contributor_sender.id,
            'receiver': self.contributor_receiver.id,
            'workspace': self.workspace.workspace_id
        }

    def test_send_collab_request(self):
        url = reverse('send_col_req')
        response = self.client.post(url, self.request_data, format='json')
        self.assertEqual(response.status_code, 201)
    
    def test_update_collab_request(self):
        url = reverse('update_req')
        response = self.client.put(url, {'id': self.request.id, 'status': 'A'}, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'A')

        receiver = Contributor.objects.get(pk=self.request_data['receiver'])
        self.assertGreater(receiver.workspaces.filter(pk=self.request_data['workspace']).count(), 0)
        # self.assert()

class ReviewRequestAPITestCase(TestCase):

    def tearDown(self):
        Workspace.objects.all().delete()
        User.objects.all().delete()
        Contributor.objects.all().delete()
        ReviewRequest.objects.all().delete()
        print("Test for the ReviewRequest API is completed!")
        
    def setUp(self):
        self.client = APIClient()

        self.workspace = Workspace.objects.create()
        self.reviewer_receiver = Contributor.objects.create(user=User.objects.create(username="receiver"))
        self.contributor_sender = Contributor.objects.create(user=User.objects.create(username="sender"))

        self.request = ReviewRequest.objects.create(workspace=self.workspace,receiver=self.reviewer_receiver,sender=self.contributor_sender)

        self.request_data = {
            'sender': self.contributor_sender.id,
            'receiver': self.reviewer_receiver.id,
            'workspace': self.workspace.workspace_id
        }

    def test_send_review_request(self):
        url = reverse('send_rev_req')
        response = self.client.post(url, self.request_data, format='json')
        self.assertEqual(response.status_code, 201)
    
    def test_update_review_request(self):
        url = reverse('update_req')
        response = self.client.put(url, {'id': self.request.id, 'status': 'R'}, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'R')


class AnswerQuestionAPITest(TestCase):
    def setUp(self):
        
        self.client = APIClient()
        self.user_for_basic = User.objects.create_user(id=1, email= 'basic_user@example.com', username='basic_user@example.com', first_name='Basic User', last_name='Test1')
        self.user_for_contributor1 = User.objects.create_user(id=2, email= 'cont1@example.com', username='cont1@example.com', first_name='Contributor User 2', last_name='Test2')
        self.user_for_contributor2 = User.objects.create_user(id=3, email= 'cont2@example.com', username='cont2@example.com', first_name='Contributor User 3', last_name='Test3')

        self.basic_user = BasicUser.objects.create(user=self.user_for_basic, bio="I am a basic user")
        self.contributor1 = Contributor.objects.create(user=self.user_for_contributor1, bio="I am the first contributor")
        self.contributor2 = Contributor.objects.create(user=self.user_for_contributor2, bio="I am the second contributor")

        self.contributor1_token = Token.objects.create(user=self.user_for_contributor1)
        
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.contributor1_token.key}")

        # Create a Node instance of Contributor1
        self.node = Node.objects.create(
            node_id=999999,
            node_title="Test Node A",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )
        self.node.contributors.add(self.contributor1)
        # Create a Question instance
        self.question = Question.objects.create(
            node=self.node,
            asker=self.basic_user,
            question_content='Sample question content?',
        )
        self.node2 = Node.objects.create(
            node_id=9999999,
            node_title="Test Node B",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )
        self.node2.contributors.add(self.contributor2)
        self.question2 = Question.objects.create(
            node=self.node2,
            asker=self.basic_user,
            question_content='Sample question content?',
        )
    def test_answer_question_success(self):
        # Define the payload
        payload = {
            'question_id': self.question.id,
            'answer_content': 'Sample answer content.'
        }
        
        url = reverse('answer_question')
        response = self.client.post(url, payload, format='json')

        # Assert that the response and question instance have been updated correctly
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_answer_strangernode_question(self):
        # Define the payload
        payload = {
            'question_id': self.question2.id,
            'answer_content': 'Sample answer content.'
        }
        url = reverse('answer_question')
        response = self.client.post(url, payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class AskQuestionAPITest(TestCase):
    def setUp(self):
        
        self.client = APIClient()
        self.user_for_basic = User.objects.create_user(id=1, email= 'basic_user@example.com', username='basic_user@example.com', first_name='Basic User', last_name='Test1')
        self.user_for_contributor1 = User.objects.create_user(id=2, email= 'cont1@example.com', username='cont1@example.com', first_name='Contributor User 2', last_name='Test2')

        self.basic_user = BasicUser.objects.create(user=self.user_for_basic, bio="I am a basic user")
        self.contributor1 = Contributor.objects.create(user=self.user_for_contributor1, bio="I am the first contributor")

        self.basic_user_token = Token.objects.create(user=self.user_for_basic)
        
        self.client.credentials(HTTP_AUTHORIZATION=f"Token {self.basic_user_token.key}")

        # Create a Node instance of Contributor1
        self.node = Node.objects.create(
            node_id=999999,
            node_title="Test Node A",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )
        self.node.contributors.add(self.contributor1)
        
    def test_ask_question_success(self):
        # Define the payload
        payload = {
            'node_id': self.node.node_id,
            'question_content': 'Sample question content?'
        }
        url = reverse('ask_question')
        response = self.client.post(url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)