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
    bio = models.CharField(max_length=200, default="This user has not told about herself / himself yet...")
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
    reviewer = models.ForeignKey(Reviewer, on_delete=models.CASCADE)
    pass