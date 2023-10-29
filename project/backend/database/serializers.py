from rest_framework import serializers
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework import status
from rest_framework.validators import UniqueValidator
# from django.contrib.auth.password_validation import validate_password

from .models import *

# Serializer to change password
class ChangePasswordSerializer(serializers.ModelSerializer):
    old_password = serializers.CharField(write_only=True, required=True)
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
      model = User
      fields = ('old_password', 'password')
    
    def validate_old_password(self, value):
      user = self.context['request'].user
      if not user.check_password(value):
          raise serializers.ValidationError({"error": "Old password is not correct"})
      return value
    
    def update(self, instance, validated_data):
      instance.set_password(validated_data['password'])
      instance.save()

      return instance

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
    to_referenced_nodes = serializers.PrimaryKeyRelatedField(many=True, queryset=Node.objects.all())
    proofs = serializers.PrimaryKeyRelatedField(many=True, queryset=Proof.objects.all())
    class Meta:
        model = Node
        fields = ['node_id', 'node_title', 'publish_date', 'is_valid', 'num_visits' , 'theorem', 'contributors',
                   'reviewers', 'from_referenced_nodes' , 'to_referenced_nodes', 'proofs' , 'semantic_tags', 'wiki_tags', 'annotations']
