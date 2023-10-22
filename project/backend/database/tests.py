from django.test import TestCase
from django.contrib.auth.models import User
from .models import BasicUser, Node, Theorem, Proof
from .serializers import RegisterSerializer, UserSerializer, BasicUserSerializer

# Create your tests here.


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
        self.assertEqual(node.node_id, 3)
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
