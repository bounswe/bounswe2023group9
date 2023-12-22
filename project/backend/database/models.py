from django.db import models
from django.contrib.auth.models import User

import copy
from datetime import datetime
import enum
from api.wikidata import *


class SemanticTag(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    wid = models.CharField(max_length=20)
    label = models.CharField(max_length=30, unique=True)
    
    @property
    def nodes(self):
        return Node.objects.filter(semantic_tags__wid=self.wid)

    @property
    def count(self):
        return self.nodes.count()
    
    @property
    def related_nodes(self):
        parent_wids = get_parent_ids(self.wid)
        for pw in parent_wids:
            if not SemanticTag.objects.filter(wid=pw).exists():
                parent_wids.remove(pw)
        sibling_wids = get_children_ids(parent_wids)

        while self.wid in sibling_wids:
            sibling_wids.remove(self.wid)

        children_wids = get_children_ids([self.wid])
        combined = sibling_wids + children_wids + parent_wids

        return Node.objects.filter(semantic_tags__wid__in=combined)

    @property
    def related_count(self):
        return self.related_nodes.count()
    
    @classmethod
    def existing_search_results(cls, keyword):
        wiki_results = search_entity(keyword)

        existings = []

        for item in wiki_results:
            node_count = Node.objects.filter(semantic_tags__wid=item["id"]).count()
            if node_count > 0:
                existings.append(item)

        return existings
    
    def __str__(self):
        return str(self.pk) + " " + self.label + " - " + self.wid

class Entry(models.Model):
    entry_id = models.AutoField(primary_key=True)
    entry_index = models.IntegerField(blank=True,null=True)
    #workspace_id =  models.ForeignKey(Workspace,null=False, blank = False, on_delete=models.CASCADE,related_name='WorkspaceID')
    content = models.TextField(null=False)
    entry_date = models.DateField(auto_now_add=True)
    is_theorem_entry = models.BooleanField(default=False)
    is_final_entry = models.BooleanField(default=False)
    is_proof_entry = models.BooleanField(default=False)
    is_disproof_entry = models.BooleanField(default=False)
    is_editable = models.BooleanField(default=True)
    #creator = models.ForeignKey(Contributor,null=True,blank=True, on_delete = models.CASCADE)
    entry_number = models.IntegerField(blank=True,null=True)
    #contributors = models.ManyToManyField(Contributor,related_name="EntryContributors")
    def set_as_final(self):
        self.is_final_entry = True
    def set_as_theorem(self):
        self.is_theorem_entry = True
    def set_entry_content(self,cont):
        self.content = cont

# Create your models here.
class Workspace(models.Model):  #Node and Review Requests may be added later
    workspace_id = models.AutoField(primary_key=True)
    workspace_title = models.CharField(max_length=100)
    semantic_tags = models.ManyToManyField(SemanticTag, blank=True,related_name = 'WorkspaceSemanticTags')
    # wiki_tags = models.ManyToManyField(WikiTag,blank=True,related_name = 'WorkspaceWikiTags')
    is_finalized = models.BooleanField(null = True,default=False)
    is_published = models.BooleanField(null = True,default=False)
    is_in_review = models.BooleanField(null = True,default=False)
    is_rejected = models.BooleanField(null = True,default=False)
    theorem_posted = models.BooleanField(null = True,default=False)
    num_approvals = models.IntegerField(null = True,default=0)
    entries = models.ManyToManyField(Entry,blank=True,related_name = 'WorkspaceEntries')
    references = models.ManyToManyField('Node',blank=True,related_name='WorkspaceReferences')
    node = models.ForeignKey('Node',on_delete=models.CASCADE,blank=True,null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    theorem_entry = models.ForeignKey('Entry',null=True,blank=True,on_delete=models.CASCADE,related_name='workspace_theorem')
    proof_entry = models.ForeignKey('Entry',null=True, blank=True, on_delete=models.CASCADE,related_name='workspace_proof')
    # theorem_entry = models.ManyToManyField(Entry,related_name='TheoremEntry')
    # final_entry = models.ForeignKey(Entry,null=True, on_
    # delete=models.CASCADE,related_name='FinalEntry')
    def finalize_workspace(self):
        self.is_finalized = True
        self.is_in_review = False
        return True




class BasicUser(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.CharField(
        max_length=200, default=""
    )
    email_notification_preference = models.BooleanField(default=False)
    show_activity_preference = models.BooleanField(default=True)
    semantic_tags = models.ManyToManyField(SemanticTag, blank=True, related_name='BasicUserSemanticTags')

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name



class Contributor(BasicUser):
    workspaces = models.ManyToManyField(Workspace, blank=True)
    orcid = models.TextField(unique=True, null=True, blank=True)
    def __str__(self):
        return self.user.first_name + " " + self.user.last_name

    """
     Methods below (create/delete Workspace instances) should be reinvestigated 
     after implementation of Workspace class.
    """
    def create_workspace(self,title):
        new_workspace = Workspace.objects.create(
            workspace_title=title,
        )
        self.workspaces.add(new_workspace)
        return new_workspace

    def delete_workspace(self, workspace_to_delete):        # Note that this function doesn't delete the
        if workspace_to_delete in self.workspaces.all():    # Workspace but pops from the list to prevent
            self.workspaces.remove(workspace_to_delete)     # errors if multiple Contributors present

class Reviewer(Contributor):
    review_workspaces =  models.ManyToManyField(Workspace, blank=True)

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name

    def get_review_requests(self):                          
        return ReviewRequest.objects.filter(receiver=self)




class Admin(BasicUser):
    def __str__(self):
        return self.user.first_name + " " + self.user.last_name



class Request(models.Model):
    request_status_choices = [
        ("P", "Pending"),
        ("A", "Accepted"),
        ("R", "Rejected")
    ]

    sender = models.ForeignKey(Contributor, on_delete=models.PROTECT, related_name="outgoing_requests")
    receiver = models.ForeignKey(Contributor, on_delete=models.PROTECT, related_name="incoming_requests")
    status = models.CharField(max_length=1, choices=request_status_choices, default="P")
    
    def accept(self):
        self.status = "A"
        self.save()
    
    def reject(self):
        self.status = "R"
        self.save()


class ReviewRequest(Request):
    """
     This class definition is written beforehand (to be implemented afterwards) 
     in order to be referred from other classes. e.g. Reviewer, Contributor
    """
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)    #Note that workspace is accessed directly by Workspace instance not via "workspaceID" as proposed in project class diagram.
    comment   = models.CharField(max_length=400, null=True, default=None)
    response = models.CharField(max_length=1, choices=Request.request_status_choices, default="P")

class CollaborationRequest(Request):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)    #Note that workspace is accessed directly by Workspace instance not via "workspaceID" as proposed in project class diagram.
    
class Theorem(models.Model):
    theorem_id = models.AutoField(primary_key=True)
    theorem_title = models.CharField(max_length=100, null=False)
    theorem_content = models.TextField(null=False)
    publish_date = models.DateField()
    contributors = models.ManyToManyField(Contributor, related_name='TheoremContributors')




class Annotation(models.Model):
    # ReviewRequest has annotations, must be handled.  
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
    annotations = models.ManyToManyField(Annotation)
    is_valid = models.BooleanField()
    num_visits = models.IntegerField()
    removed_by_admin = models.BooleanField(default=False)

    def increment_num_visits(self):
        self.num_visits += 1

class Proof(models.Model):
    proof_id = models.AutoField(primary_key=True)
    proof_title = models.CharField(max_length=100, null=False)
    proof_content = models.TextField(null=False)
    is_valid = models.BooleanField()
    is_disproof = models.BooleanField()
    publish_date = models.DateField()
    removed_by_admin = models.BooleanField(default=False)
    contributors = models.ManyToManyField(Contributor, related_name='ProofContributors')
    node = models.ForeignKey(Node, on_delete=models.CASCADE, related_name="proofs")


class Question(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    node = models.ForeignKey(Node, on_delete=models.CASCADE)

    asker = models.ForeignKey(BasicUser, on_delete=models.PROTECT, related_name="asked_questions")
    question_content = models.TextField(max_length=400)

    answerer = models.ForeignKey(Contributor, on_delete=models.PROTECT, null=True, blank=True, related_name="answered_questions")
    answer_content = models.TextField(max_length=600, null=True, blank=True)
    answered_at = models.DateTimeField(null=True, blank=True)
    removed_by_admin = models.BooleanField(default=False)
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
