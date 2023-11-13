from django.test import TestCase
from django.contrib.auth.models import User
from .models import *
from .serializers import RegisterSerializer, UserSerializer, BasicUserSerializer, ContributorSerializer, ReviewerSerializer
from .models import BasicUser, Node, Theorem, Proof, Request, ReviewRequest, CollaborationRequest
from .serializers import RegisterSerializer, UserSerializer, BasicUserSerializer

# Create your tests here.

"""
class BasicUserModelTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        print("All tests for the Basic User Model are completed!")

    def test_basic_user_create(self):
        # Testing the creation of a new basic user

        user = User.objects.create(
            username="test@example.com",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        basic_user = BasicUser.objects.create(user=user, bio="Test Bio")

        self.assertEqual(basic_user.user, user)
        self.assertEqual(basic_user.bio, "Test Bio")

        # Testing with default values
        self.assertFalse(basic_user.email_notification_preference)
        self.assertTrue(basic_user.show_activity_preference)

    def test_basic_user_str(self):
        user = User.objects.create(
            username="test@example.com",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        basic_user = BasicUser.objects.create(user=user)

        self.assertEqual(str(basic_user), f"{user.first_name} {user.last_name}")

class ContributorModelTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        Contributor.objects.all().delete()
        print("All tests for the Contributor Model are completed!")

    def test_contributor_create(self):
        # Testing the creation of a new Contributor

        user = User.objects.create(
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        contributor = Contributor.objects.create(user=user, bio="Test Bio")

        self.assertEqual(contributor.user, user)
        self.assertEqual(contributor.bio, "Test Bio")

        # Testing with default values
        self.assertFalse(contributor.email_notification_preference)
        self.assertTrue(contributor.show_activity_preference)

    def test_create_workspace(self):
        # Test the create_workspace method
        contributor = Contributor.objects.create(user=User.objects.create())
        workspace = contributor.create_workspace()
        self.assertIn(workspace, contributor.workspaces.all())
        
        # We should collect our garbages
        contributor.delete() 
        workspace.delete()


    def test_delete_workspace(self):
        # Create a workspace and add it to the contributor
        contributor = Contributor.objects.create(user=User.objects.create())
        workspace = Workspace.objects.create()
        contributor.workspaces.add(workspace)

        # Test the delete_workspace method
        contributor.delete_workspace(workspace)
        self.assertNotIn(workspace, contributor.workspaces.all())
        
        # We should collect our garbages
        contributor.delete() 
        workspace.delete() 


    def test_delete_nonexistent_workspace(self):
        # Create a workspace, but don't add it to the contributor
        contributor = Contributor.objects.create(user=User.objects.create())
        workspace = Workspace.objects.create()

        # Test the delete_workspace method with a non-existent workspace
        contributor.delete_workspace(workspace)  # This should not raise an error
        
        # We should collect our garbages 
        contributor.delete() 
        workspace.delete()

class ReviewerModelTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        Contributor.objects.all().delete()
        Reviewer.objects.all().delete
        print("All tests for the Reviewer Model are completed!")
    
    def test_reviewer_create(self):
        # Testing the creation of a new Reviewer
        user = User.objects.create(
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        reviewer = Reviewer.objects.create(user=user)


        self.assertEqual(reviewer.user, user)

        # Testing with default values
        self.assertFalse(reviewer.email_notification_preference)
        self.assertTrue(reviewer.show_activity_preference)

    def test_get_review_requests(self):
        # Create reviewer instances, note that username is a key.
        reviewer1=Reviewer.objects.create(user=User.objects.create(username="First"))
        reviewer2=Reviewer.objects.create(user=User.objects.create(username="Second"))
        workspace = Workspace.objects.create()

        # Create review requests associated with the reviewer1
        review_request1 = ReviewRequest.objects.create(reviewer=reviewer1, workspace=workspace)
        review_request2 = ReviewRequest.objects.create(reviewer=reviewer1, workspace=workspace)

        # Create a review request not associated with the reviewer1
        other_review_request = ReviewRequest.objects.create(reviewer=reviewer2,workspace=workspace)

        review_requests = reviewer1.get_review_requests()

        # Ensure that the reviewer's review requests are in the queryset
        self.assertIn(review_request1, review_requests)
        self.assertIn(review_request2, review_requests)

        # Ensure that the other_review_request is not in the queryset
        self.assertNotIn(other_review_request, review_requests)
        
        # We should collect our garbages
        other_review_request.delete() 
        review_requests.delete()
        review_request1.delete() 
        review_request2.delete() 
        reviewer1.delete() 
        reviewer2.delete() 
    
    def test_inheritance(self):
        # Create a contributor and it's workspace
        contributor = Contributor.objects.create(user=User.objects.create())
        workspace = contributor.create_workspace()

        # Suppose this particular contributor becomes a reviewer
        contributor.__class__= Reviewer
        contributor.save()
        reviewer = contributor

        # Review request is issued to new reviewer
        
        review_request = ReviewRequest.objects.create(reviewer=reviewer, workspace=workspace)
        self.assertIn(review_request, reviewer.get_review_requests())

        # Check if workspace is inherited
        self.assertIn(workspace, reviewer.workspaces.all())
        
        # We should collect our garbages
        review_request.delete()
        workspace.delete()
        reviewer.delete()

class AdminModelTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        Node.objects.all().delete()
        Admin.objects.all().delete()
        
        print("Test for the Admin Model is completed!")

    def test_admin_create(self):
        # Testing the creation of a new Admin

        user = User.objects.create(
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        admin = Admin.objects.create(user=user)

        self.assertEqual(admin.user, user)

        # Testing with default values
        self.assertFalse(admin.email_notification_preference)
        self.assertTrue(admin.show_activity_preference)
        

class NodeModelTestCase(TestCase):
    def tearDown(self):
        Node.objects.all().delete()
        print("All tests for the Node Model are completed!")

    def test_node_model(self):
        # Testing the creation of a node
        node = Node.objects.create(
            node_title="Test Node",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=99,
        )
        # self.assertEqual(node.node_id, 3) # after changing node_id to AutoField these tests became redundant
        self.assertEqual(node.node_title, "Test Node")
        self.assertEqual(node.is_valid, True)
        self.assertEqual(node.num_visits, 99)

        # TODO: These tests should be hanled after the models below implemented
        # self.assertIsNone(node.reviewers)
        # self.assertIsNone(node.referenced_nodes)
        # self.assertIsNone(node.semantic_tags)
        # self.assertIsNone(node.wiki_tags)
        # self.assertIsNone(node.annotations)

    def test_increment_num_visits(self):
        # Testing the incrementing num of visits function
        node = Node.objects.create(
            node_title="Test Node",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=99,
        )
        node.increment_num_visits()
        self.assertEqual(node.num_visits, 100)


class NodeReferenceTestCase(TestCase):
    def setUp(self):
        self.node_A = Node.objects.create(
            node_title="Test Node A",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )
        self.node_B = Node.objects.create(
            node_title="Test Node B",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )
        self.node_C = Node.objects.create(
            node_title="Test Node C",
            theorem=None,
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )

    def tearDown(self):
        Node.objects.all().delete()
        print("All tests for the Node Reference Model are completed!")

    def test_references(self):
        self.node_B.from_referenced_nodes.add(self.node_A)
        self.node_C.from_referenced_nodes.add(self.node_B)

        self.assertEqual(self.node_B.from_referenced_nodes.first(), self.node_A)
        self.assertEqual(self.node_B.to_referenced_nodes.first(), self.node_C)

    def test_reference_symmetry(self):
        self.node_A.from_referenced_nodes.add(self.node_B)
        self.node_B.from_referenced_nodes.add(self.node_A)

        from_reference_A = self.node_A.from_referenced_nodes.first()
        to_reference_A = self.node_A.to_referenced_nodes.first()
        from_reference_B = self.node_B.from_referenced_nodes.first()
        to_reference_B = self.node_B.to_referenced_nodes.first()

        self.assertEqual(from_reference_A, self.node_B)
        self.assertEqual(to_reference_A, self.node_B)
        self.assertEqual(from_reference_B, self.node_A)
        self.assertEqual(to_reference_B, self.node_A)


class ProofModelTestCase(TestCase):
    def tearDown(self):
        Node.objects.all().delete()
        Proof.objects.all().delete()
        print("All tests for the Proof Model are completed!")

    def test_proof_model(self):
        test_node = Node.objects.create(
            node_title="Test Node",
            publish_date="2023-01-01",
            is_valid=True,
            num_visits=0,
        )

        proof = Proof.objects.create(
            proof_title="Test Proof",
            proof_content="This is a test proof content.",
            is_valid=True,
            is_disproof=False,
            publish_date="2023-01-01",
            node=test_node,
        )
        self.assertEqual(proof.proof_id, 1)
        self.assertEqual(proof.proof_title, "Test Proof")
        self.assertEqual(proof.proof_content, "This is a test proof content.")
        self.assertEqual(proof.is_valid, True)
        self.assertEqual(proof.is_disproof, False)
        self.assertIsNotNone(proof.node)
        self.assertEqual(len(test_node.proofs.all()), 1)


class TheoremModelTestCase(TestCase):
    def tearDown(self):
        Theorem.objects.all().delete()
        print("All tests for the Theorem Model are completed!")

    def test_theorem_model(self):
        theorem = Theorem.objects.create(
            theorem_title="Test Theorem",
            theorem_content="This is a test theorem content.",
            publish_date="2023-01-01",
        )
        self.assertEqual(theorem.theorem_id, 1)
        self.assertEqual(theorem.theorem_title, "Test Theorem")
        self.assertEqual(theorem.theorem_content, "This is a test theorem content.")
"""
class ReviewRequestTestCase(TestCase):
    def tearDown(self):
        Workspace.objects.all().delete()
        User.objects.all().delete()
        ReviewRequest.objects.all().delete()
        
        print("Test for the ReviewRequest Model is completed!")

    def setUp(self):
        # Setup run before every test method.
        self.workspace = Workspace.objects.create()
        self.reviewer = Reviewer.objects.create(user=User.objects.create(username="receiver"))
        self.contributor = Contributor.objects.create(user=User.objects.create())
        self.request = ReviewRequest.objects.create(sender=self.contributor,receiver=self.reviewer,workspace=self.workspace, comment='Initial Comment')
    def test_accept(self):
        self.request.accept()
        req = ReviewRequest.objects.get(sender=self.contributor)
        self.assertEqual(req.status, "A", "Accept method didn't work as expected")

    def test_reject(self):
        self.request.reject()
        req = Request.objects.get(sender=self.contributor)
        self.assertEqual(req.status, "R", "Reject method didn't work as expected")    

class CollaborationRequestTestCase(TestCase):
    def tearDown(self):
        Workspace.objects.all().delete()
        User.objects.all().delete()
        Contributor.objects.all().delete()
        CollaborationRequest.objects.all().delete()
        print("Test for the CollaborationRequest Model is completed!")
    def setUp(self):
        # Set up Workspace and Contributor instances to be used in the tests
        self.workspace = Workspace.objects.create()
        self.contributor_receiver = Contributor.objects.create(user=User.objects.create(username="receiver"))
        self.contributor_sender = Contributor.objects.create(user=User.objects.create(username="sender"))
        self.request = CollaborationRequest.objects.create(workspace=self.workspace,receiver=self.contributor_receiver,sender=self.contributor_sender)
    def test_accept(self):
        self.request.accept()
        req = CollaborationRequest.objects.get(sender=self.contributor_sender)
        self.assertEqual(req.status, "A", "Accept method didn't work as expected")

    def test_reject(self):
        self.request.reject()
        req = Request.objects.get(sender=self.contributor_sender)
        self.assertEqual(req.status, "R", "Reject method didn't work as expected")

class RequestModelTestCase(TestCase):
    def tearDown(self):
        Request.objects.all().delete()
        Contributor.objects.all().delete()

    def setUp(self):
        sender_user = User.objects.create(
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        self.sender = Contributor.objects.create(user=sender_user, bio="Test bio 1")

        receiver_user = User.objects.create(
            username="testuser2",
            email="test2@example.com",
            first_name="User2",
            last_name="Test2",
        )
        self.receiver = Contributor.objects.create(user=receiver_user, bio="Test bio 2")
        self.request = Request.objects.create(sender=self.sender, receiver=self.receiver, title="Request title", body="Request body")

    def test_db(self):
        self.assertGreater(Request.objects.filter(sender=self.sender).count(), 0, "Could not find created request in the db with this sender!")
        req = Request.objects.get(sender=self.sender)
        self.assertEqual(req.receiver.id, self.receiver.id, "Receiver didn't match")
        self.assertEqual(req.title, self.request.title, "Title didn't match")
        self.assertEqual(req.body, self.request.body, "Body didn't match")
        self.assertEqual(self.request.status, "P", "Status is not Pending")

    def test_accept(self):
        self.request.accept()
        req = Request.objects.get(sender=self.sender)
        self.assertEqual(req.status, "A", "Accept method didn't work as expected")

    def test_reject(self):
        self.request.reject()
        req = Request.objects.get(sender=self.sender)
        self.assertEqual(req.status, "R", "Reject method didn't work as expected")
"""
class RegisterSerializerTestCase(TestCase):
    def setUp(self):
        self.data = {
            "password": "testpassword",
            "email": "test@example.com",
            "first_name": "User",
            "last_name": "Test",
        }

    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        print("All tests for the RegisterSerializer are completed!")

    def test_validate_true(self):
        # Testing the validate function for valid credentials
        serializer = RegisterSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    # def test_validate_false(self):
    #     # Testing the validate function for invalid credentials
    #     data = self.data
    #     data["password2"] = "wrong"
    #     serializer = RegisterSerializer(data=data)
    #     self.assertFalse(serializer.is_valid())

    def test_create(self):
        # Testing the create function
        serializer = RegisterSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

        user = serializer.create(serializer.validated_data)
        self.assertIsInstance(user, User)
        # self.assertEqual(user.username, self.data["username"])
        self.assertEqual(user.email, self.data["email"])
        self.assertEqual(user.first_name, self.data["first_name"])
        self.assertEqual(user.last_name, self.data["last_name"])
        self.assertTrue(user.check_password(self.data["password"]))


class UserSerializerTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        print("All tests for the UserSerializer are completed!")

    def test_user_serializer_fields(self):
        # Testing the fiels of the serializer
        user = User.objects.create(
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        serializer = UserSerializer(user)
        expected_fields = set(["id", "email", "first_name", "last_name"])
        self.assertEqual(set(serializer.data.keys()), expected_fields)


class BasicUserSerializerTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        print("All tests for the BasicUserSerializer are completed!")

    def test_basic_user_serializer_fields(self):
        # Testing the fiels of the serializer
        user = User.objects.create(
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        basic_user = BasicUser.objects.create(user=user)
        serializer = BasicUserSerializer(basic_user)
        expected_fields = set(
            ["user", "bio", "email_notification_preference", "show_activity_preference"]
        )
        self.assertEqual(set(serializer.data.keys()), expected_fields)


class ContributorSerializerTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        Contributor.objects.all().delete()
        print("All tests for the ContributorSerializer are completed!")

    def test_contributor_serializer_fields(self):
        # Testing the fiels of the serializer
        
        contributor = Contributor.objects.create(user=User.objects.create())
        workspace = contributor.create_workspace()

        serializer = ContributorSerializer(contributor)
        expected_fields = set(
            ["user", "bio", "email_notification_preference", "show_activity_preference", "workspaces"]
        )
        self.assertEqual(set(serializer.data.keys()), expected_fields)

class ReviewerSerializerTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        Reviewer.objects.all().delete()
        print("All tests for the ReviewerSerializer are completed!")

    def test_reviewer_serializer_fields(self):
        # Testing the fiels of the serializer
        
        reviewer = Reviewer.objects.create(user=User.objects.create())
        workspace = reviewer.create_workspace()

        serializer = ReviewerSerializer(reviewer)
        expected_fields = set(
            ["user", "bio", "email_notification_preference", "show_activity_preference", "workspaces"]
        )
        self.assertEqual(set(serializer.data.keys()), expected_fields)

"""