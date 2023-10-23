from django.db import models
from django.contrib.auth.models import User

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
        max_length=200, default="This user has not told about herself / himself yet..."
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

    def __init__(self, *args, **kwargs):
        super(Admin, self).__init__(*args, **kwargs)    # Constructor to specify inherited fields. 
        self.removed_nodes  = []                        # Array keeping removed nodes  by this admin.
        self.removed_proofs = []                        # Array keeping removed proofs by this admin.
    
    def add_removed_nodes(self, node):
       if isinstance(node, Node):
           self.removed_nodes.append(node)
       else:
           raise ValueError("Only Node objects can be added to the admin's list.")

    def pop_removed_nodes(self, node):
        if node in self.removed_nodes:
            self.removed_nodes.remove(node)
        else:
            raise ValueError("Node not found in the admin's list.")
        
    def add_removed_proofs(self, proof):
       if isinstance(proof, Proof):
           self.removed_proofs.append(proof)
       else:
           raise ValueError("Only Proof objects can be added to the admin's list.")
    
    def pop_removed_proofs(self, proof):
        if proof in self.removed_proofs:
            self.removed_proofs.remove(proof)
        else:
            raise ValueError("Proof not found in the admin's list.")

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name
   
class Trial(models.Model):
    def __str__(self):
        return "Trial"

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
    theorem_id = models.IntegerField(primary_key=True)
    theorem_title = models.CharField(max_length=100, null=False)
    theorem_content = models.TextField(null=False)
    publish_date = models.DateField()


class SemanticTag(models.Model):
    pass


class WikiTag(models.Model):
    pass


class Annotation(models.Model):
    pass


class Node(models.Model):
    node_id = models.IntegerField(primary_key=True)
    node_title = models.CharField(max_length=100)
    contributors = models.ManyToManyField(Contributor,related_name='NodeContributors')
    theorem = models.OneToOneField(Theorem, null=True, on_delete=models.SET_NULL)
    publish_date = models.DateField()
    reviewers = models.ManyToManyField(Reviewer,related_name='NodeReviewers')
    from_referenced_nodes = models.ManyToManyField(
        "self", related_name="to_referenced_nodes", symmetrical=False
    )
    semantic_tags = models.ManyToManyField(SemanticTag)
    wiki_tags = models.ManyToManyField(WikiTag)
    annotations = models.ManyToManyField(Annotation)
    is_valid = models.BooleanField()
    num_visits = models.IntegerField()

    def increment_num_visits(self):
        self.num_visits += 1


class Proof(models.Model):
    proof_id = models.IntegerField(primary_key=True)
    proof_title = models.CharField(max_length=100, null=False)
    proof_content = models.TextField(null=False)
    is_valid = models.BooleanField()
    is_disproof = models.BooleanField()
    publish_date = models.DateField()

    node = models.ForeignKey(Node, on_delete=models.CASCADE, related_name="proofs")


# class Question(models.Model):
#     node = models.ForeignKey(Node,models.CASCADE)
