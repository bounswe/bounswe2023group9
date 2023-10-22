from django.test import TestCase
from django.contrib.auth.models import User
from .models import BasicUser
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