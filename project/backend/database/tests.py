from django.test import TestCase
from django.contrib.auth.models import User
from .models import Workspace, BasicUser, Contributor
from .serializers import RegisterSerializer, UserSerializer, BasicUserSerializer

# Create your tests here.

class ContributorModelTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
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

class BasicUserModelTestCase(TestCase):
    def tearDown(self):
        User.objects.all().delete()
        BasicUser.objects.all().delete()
        print("All tests for the Basic User Model are completed!")

    def test_basic_user_create(self):
        # Testing the creation of a new basic user

        user = User.objects.create(
            username="testuser",
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
            username="testuser",
            email="test@example.com",
            first_name="User",
            last_name="Test",
        )
        basic_user = BasicUser.objects.create(user=user)

        self.assertEqual(str(basic_user), f"{user.first_name} {user.last_name}")


class RegisterSerializerTestCase(TestCase):
    def setUp(self):
        self.data = {
            "username": "testuser",
            "password": "testpassword",
            "password2": "testpassword",
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

    def test_validate_false(self):
        # Testing the validate function for invalid credentials
        data = self.data
        data["password2"] = "wrong"
        serializer = RegisterSerializer(data=data)
        self.assertFalse(serializer.is_valid())

    def test_create(self):
        # Testing the create function
        serializer = RegisterSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

        user = serializer.create(serializer.validated_data)
        self.assertIsInstance(user, User)
        self.assertEqual(user.username, self.data["username"])
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
        expected_fields = set(["id", "email", "first_name", "last_name", "username"])
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
