from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class BasicUser(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.CharField(
        max_length=200, default="This user has not told about herself / himself yet..."
    )
    email_notification_preference = models.BooleanField(default=False)
    show_activity_preference = models.BooleanField(default=True)

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name


class Contributor(models.Model):
    pass


class Reviewer(models.Model):
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
    contributors = models.ManyToManyField(Contributor)
    theorem = models.OneToOneField(Theorem, null=True, on_delete=models.SET_NULL)
    publish_date = models.DateField()
    reviewers = models.ManyToManyField(Reviewer)
    referenced_nodes = models.ManyToManyField("self", symmetrical=True)
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

    node = models.ForeignKey(Node, on_delete=models.CASCADE)


# class Question(models.Model):
#     node = models.ForeignKey(Node,models.CASCADE)

