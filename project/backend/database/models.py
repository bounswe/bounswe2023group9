from django.db import models
from django.contrib.auth.models import User

import copy
from datetime import datetime

# Create your models here.
class Workspace(models.Model):
    """
     This class definition is written beforehand (to be implemented afterwards) 
     in order to be referred from other classes. e.g. Contributor
    """
    pass


class BasicUser(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.CharField(
        max_length=200, default=""
    )
    email_notification_preference = models.BooleanField(default=False)
    show_activity_preference = models.BooleanField(default=True)

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name



class Contributor(BasicUser):
    workspaces = models.ManyToManyField(Workspace)

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name
    
    """
     Methods below (create/delete Workspace instances) should be reinvestigated 
     after implementation of Workspace class.
    """
    def create_workspace(self):
        new_workspace = Workspace.objects.create()
        self. workspaces.add(new_workspace)
        return new_workspace
      
    def delete_workspace(self, workspace_to_delete):        # Note that this function doesn't delete the
        if workspace_to_delete in self.workspaces.all():    # Workspace but pops from the list to prevent 
            self.workspaces.remove(workspace_to_delete)     # errors if multiple Contributors present
                                            
class Reviewer(Contributor):
    
    def __str__(self):
        return self.user.first_name + " " + self.user.last_name
    
    def get_review_requests(self):                          
        return ReviewRequest.objects.filter(reviewer=self)

class Admin(BasicUser):
    def __str__(self):
        return self.user.first_name + " " + self.user.last_name
    
class Request(models.Model):
    """
     This class definition is written beforehand (to be implemented afterwards) 
     in order to be referred from other classes. e.g. ReviewRequest
    """
    pass
class ReviewRequest(Request):
    """
     This class definition is written beforehand (to be implemented afterwards) 
     in order to be referred from other classes. e.g. Reviewer, Contributor
    """

    # Note that reviewer is accessed directly by Reviewer instance,
    # not via "receiverUserID" as proposed in project class diagram.
    reviewer = models.ForeignKey(Reviewer, on_delete=models.CASCADE)
    pass




class Theorem(models.Model):
    theorem_id = models.AutoField(primary_key=True)
    theorem_content = models.TextField(null=False)
    publish_date = models.DateField()


class SemanticTag(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    label = models.CharField(max_length=50, unique=True)
    desc = models.CharField(max_length=100)
    parent_tag = models.ForeignKey("SemanticTag", on_delete=models.CASCADE, null=True, blank=True, related_name="sub_tags")

    @property
    def count(self):
        return self.node_set.all().count()
    
    @property
    def nodes(self):
        return self.node_set.all()
    
    @property
    def recursive_nodes(self):
        nodes = list(self.nodes)

        for sub in self.sub_tags.all():
            nodes.extend(sub.recursive_nodes)

        return nodes

    @property
    def recursive_count(self):
        return len(self.recursive_nodes)
    
    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['label', 'parent_tag'], name='semantictag_label_parenttag_unique_constraint')
        ]


class WikiTag(models.Model):
    pass


class Annotation(models.Model):
    pass


class Node(models.Model):
    node_id = models.AutoField(primary_key=True)
    node_title = models.CharField(max_length=100)
    contributors = models.ManyToManyField(Contributor,related_name='NodeContributors')
    theorem = models.OneToOneField(Theorem, null=True, on_delete=models.SET_NULL)
    publish_date = models.DateField()
    reviewers = models.ManyToManyField(Reviewer,related_name='NodeReviewers')
    from_referenced_nodes = models.ManyToManyField(
        "self", related_name="to_referenced_nodes", symmetrical=False
    )
    # Nodes also have to_referenced_nodes list to access the nodes this node references
    # Nodes also have a 'proofs' list which can be accessed as Node.proofs.all()
    semantic_tags = models.ManyToManyField(SemanticTag)
    wiki_tags = models.ManyToManyField(WikiTag)
    annotations = models.ManyToManyField(Annotation)
    is_valid = models.BooleanField()
    num_visits = models.IntegerField()
    removed_by_admin = models.BooleanField(default=False)


    def increment_num_visits(self):
        self.num_visits += 1


class Proof(models.Model):
    proof_id = models.AutoField(primary_key=True)
    proof_content = models.TextField(null=False)
    is_valid = models.BooleanField()
    is_disproof = models.BooleanField()
    publish_date = models.DateField()
    removed_by_admin = models.BooleanField(default=False)

    node = models.ForeignKey(Node, on_delete=models.CASCADE, related_name="proofs")


class Question(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    node = models.ForeignKey(Node, on_delete=models.CASCADE)

    asker = models.ForeignKey(BasicUser, on_delete=models.PROTECT, related_name="asked_questions")
    question_content = models.TextField(max_length=400)

    answerer = models.ForeignKey(Contributor, on_delete=models.PROTECT, null=True, blank=True, related_name="answered_questions")
    answer_content = models.TextField(max_length=600, null=True, blank=True)
    answered_at = models.DateTimeField(null=True, blank=True)

    def answer(self, answer, answerer):
        if self.answer_content is None or self.answer_content == "":
            print("first if")
            if answerer in self.node.contributors.all():
                print("second if")
                self.answer_content = answer
                self.answerer = answerer
                self.answered_at = datetime.now()
                self.save()
                return True
        
        return False
