from django.db import models
from django.contrib.auth.models import User

import json

# Create your models here.

class Paper(models.Model):
    paper_id = models.AutoField(primary_key=True)
    third_party_id = models.CharField(max_length=100)
    source = models.CharField(max_length=50)
    abstract = models.TextField(max_length=5000, blank=True, null=True)
    year = models.IntegerField(blank=True, null=True)
    url = models.URLField()
    authors = models.TextField(max_length=500, blank=True, null=True)
    title = models.CharField(max_length=300)
    like_count = models.IntegerField()

    def set_authors(self, authors):
        self.authors = json.dumps(authors)

    def get_authors(self):
        return json.loads(self.authors) if self.authors else []

class Comment(models.Model):
    # comment_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    paper =  models.ForeignKey(Paper, on_delete=models.CASCADE)
    text = models.TextField(max_length=500)

class Like(models.Model):
    # like_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    paper = models.ForeignKey(Paper, on_delete=models.CASCADE)


class UserInterest(models.Model):
    # interest_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    interest = models.CharField(max_length=50, blank=True, null=True)

class PaperList(models.Model):
    #list_id = models.AutoField(primary_key=True)
    list_title = models.CharField(max_length=50, default='Paper List')
    paper = models.ManyToManyField(Paper, blank=True, null=True)
    owner = models.ForeignKey(User, related_name='owner', on_delete=models.CASCADE)
    saver = models.ManyToManyField(User, related_name='savers', blank=True, null=True)

class FollowRequest(models.Model):
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sender')
    receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='receiver')
    status = models.CharField(max_length=50)

class Follower(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='user')
    follower = models.ManyToManyField(User, related_name='followers', blank=True, null=True)
    followed = models.ManyToManyField(User, related_name='followeds', blank=True, null=True)