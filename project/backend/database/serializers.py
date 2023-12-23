from rest_framework import serializers
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework import status
from rest_framework.validators import UniqueValidator
from database.models import Contributor
# from django.contrib.auth.password_validation import validate_password

from .models import *

class WorkspaceSerializer(serializers.ModelSerializer):
    semantic_tags = serializers.PrimaryKeyRelatedField(many=True, queryset=SemanticTag.objects.all(), required=False)
    workspace_id = serializers.IntegerField(required=False)
    workspace_title = serializers.CharField(required=False)

    class Meta:
        model = Workspace
        fields = [
            'workspace_id',
            'workspace_title', 
            'semantic_tags'
        ]

    def validate(self, data):
      workspace_id = data.get('workspace_id')
      workspace_title = data.get('workspace_title')
      tags = data.get('semantic_tags')

      if workspace_id is None and workspace_title is None:
        raise serializers.ValidationError("Both workspace_id and workspace_title cannot be empty.")

      if tags is None and workspace_title is None:
        raise serializers.ValidationError("Both workspace_title and semantic_tags cannot be empty.")

      return data

    def create(self, validated_data):
      workspace_id = validated_data.get('workspace_id', None)
      title = validated_data.get('workspace_title', None)
      
      if workspace_id is not None:
        workspace = Workspace.objects.get(workspace_id=workspace_id)
        created = False
      else:
        workspace = Workspace.objects.create(workspace_title=title)
        created = True
      
      if created:
        self.context['request'].user.basicuser.contributor.workspaces.add(workspace)
        tags = validated_data.get('semantic_tags', None)
        if tags is not None:
          workspace.semantic_tags.add(*tags)
      
      else:
        if title:
          workspace.workspace_title = title
          workspace.save()

        tags = validated_data.get('semantic_tags', None)
        if tags is not None:
          for tag in workspace.semantic_tags.all():
            if tag not in tags:
              workspace.semantic_tags.remove(tag)

          for tag in tags:
            if tag not in workspace.semantic_tags.all():
              workspace.semantic_tags.add(tag)

      return workspace

class SemanticTagSerializer(serializers.ModelSerializer):
    wid = serializers.CharField(required=True)
    label = serializers.CharField(required=True)

    class Meta:
        model = SemanticTag
        fields = "__all__"

    def create(self, validated_data):
      wid = validated_data.get('wid', None)
      label = validated_data.get('label', None)
      workspace_id = self.context['request'].data.get('workspace_id', None)

      tag = SemanticTag.objects.create(wid=wid, label=label)

      if workspace_id is not None:
        workspace = Workspace.objects.get(workspace_id=workspace_id)
        workspace.semantic_tags.add(tag)

      return tag

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

# Serializer to change password
class ChangeProfileSettingsSerializer(serializers.ModelSerializer):
    bio = serializers.CharField(required=False)
    email_notification_preference = serializers.BooleanField(required=False, allow_null=True, default=None)
    show_activity_preference = serializers.BooleanField(required=False, allow_null=True, default=None)
    orcid = serializers.CharField(required=False, allow_null=True, default=None)
    class Meta:
      model = BasicUser
      fields = ('bio', 'email_notification_preference', 'show_activity_preference', 'orcid')
    
    def update(self, instance, validated_data):
      change = False

      if "bio" in validated_data:
        instance.bio = validated_data['bio']
        change = True
      
      if 'email_notification_preference' in validated_data:
        if validated_data['email_notification_preference'] is not None:
          instance.email_notification_preference = validated_data['email_notification_preference']
          change = True

      if 'show_activity_preference' in validated_data:
        if validated_data['show_activity_preference'] is not None:
          instance.show_activity_preference = validated_data['show_activity_preference']
          change = True

      if 'orcid' in validated_data:
        if validated_data['orcid'] is not None:
          cont =  Contributor.objects.filter(user_id=instance.user.id)
          if cont.count() != 0 and cont[0].orcid == None:
            contributor_serializer = ContributorSerializer(cont[0], data={'orcid': validated_data['orcid']}, partial=True)
            if contributor_serializer.is_valid():
              contributor_serializer.save()
              change = True
              cont[0].save()
          instance.save()
          return cont[0]

      if change:
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
    fields = ["user", "bio", "email_notification_preference", "show_activity_preference", "workspaces","orcid"]
    
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
  
class NodeViewProofSerializer(serializers.ModelSerializer):
  class Meta:
    model = Proof
    fields = ['proof_content', 'publish_date','contributors']

class NodeViewTheoremSerializer(serializers.ModelSerializer):
  class Meta:
    model = Theorem
    fields = ['theorem_content', 'publish_date','contributors']

class NodeViewBasicUserSerializer(serializers.ModelSerializer):
  first_name = serializers.CharField(source='user.first_name', read_only=True)
  last_name = serializers.CharField(source='user.last_name', read_only=True)
  username = serializers.CharField(source='user.username', read_only=True)
  class Meta:
    model = BasicUser
    fields = ['id', 'first_name', 'last_name', 'username']

class NodeViewQuestionSerializer(serializers.ModelSerializer):
  asker = NodeViewBasicUserSerializer()
  answerer = NodeViewBasicUserSerializer()
  class Meta:
    model = Question
    fields = ['id', 'question_content', 'created_at', 'asker', 'answer_content', 'answerer', 'answered_at', 'removed_by_admin']

# Serializer for Node References
class NodeViewReferenceSerializer(serializers.ModelSerializer):
  contributors = NodeViewBasicUserSerializer(many=True)
  class Meta:
    model = Node
    fields = ['node_id', 'node_title', 'contributors', 'publish_date']

# Serializer to Node
class NodeSerializer(serializers.ModelSerializer):
  to_referenced_nodes = NodeViewReferenceSerializer(many=True)
  from_referenced_nodes = NodeViewReferenceSerializer(many=True)
  proofs = NodeViewProofSerializer(many=True)
  theorem = NodeViewTheoremSerializer()
  question_set = NodeViewQuestionSerializer(many=True)
  contributors = NodeViewBasicUserSerializer(many=True)
  class Meta:
    model = Node
    fields = ['node_id', 'node_title', 'publish_date', 'is_valid', 'num_visits' , 'theorem', 'contributors',
                   'reviewers', 'from_referenced_nodes' , 'to_referenced_nodes', 'proofs' , 'question_set', 'semantic_tags', 'annotations', 'removed_by_admin']

class RequestSerializer(serializers.ModelSerializer):
  class Meta:
    model = Request
    fields = '__all__'

class CollaborationRequestSerializer(serializers.ModelSerializer):
  class Meta:
    model = CollaborationRequest
    fields = '__all__'

class ReviewRequestSerializer(serializers.ModelSerializer):
  class Meta:
    model = ReviewRequest
    fields = '__all__'