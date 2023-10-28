from rest_framework import serializers
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework import status
from rest_framework.validators import UniqueValidator
# from django.contrib.auth.password_validation import validate_password

from .models import *

# Serializer to get User details using Django Token Authentication
class UserSerializer(serializers.ModelSerializer):
  class Meta:
    model = User
    fields = ["id", "email", "first_name", "last_name"]
# Serializer to get BasicUser details
class BasicUserSerializer(serializers.ModelSerializer):
  class Meta:
    model = BasicUser
    fields = ["user", "bio", "email_notification_preference", "show_activity_preference"]

# Serializer to get Contributor details
class ContributorSerializer(serializers.ModelSerializer):
  class Meta:
    model = Contributor
    fields = ["user", "bio", "email_notification_preference", "show_activity_preference", "workspaces"]
    
# Serializer to get Reviewer details
class ReviewerSerializer(serializers.ModelSerializer):
  class Meta:
    model = Reviewer
    fields = ["user", "bio", "email_notification_preference", "show_activity_preference", "workspaces"]

# Serializer to Register User
class RegisterSerializer(serializers.ModelSerializer):
  email = serializers.EmailField(
    required=True,
    validators=[UniqueValidator(queryset=User.objects.all())]
  )
  password = serializers.CharField(write_only=True, required=True)
  # password2 = serializers.CharField(write_only=True, required=True)

  class Meta:
    model = User
    fields = ('password', 'email', 'first_name', 'last_name')
    extra_kwargs = {
      'first_name': {'required': True},
      'last_name': {'required': True}
    }

  # def validate(self, attrs):
  #   if attrs['password'] != attrs['password2']:
  #     raise serializers.ValidationError({"password": "Password fields didn't match."})
    
    # return attrs
  
  # This method will be used when generic create api called
  def create(self, validated_data):
    user = User.objects.create(
      username=validated_data['email'],
      email=validated_data['email'],
      first_name=validated_data['first_name'],
      last_name=validated_data['last_name']
    )
    user.set_password(validated_data['password'])
    user.save()

    # Create and set the basic user of the user 
    b_user = BasicUser.objects.create(
      user = user
    )

    b_user.save()

    return user
  
# Serializer to Node
class NodeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Node
        exclude = ["removed_by_admin"]
