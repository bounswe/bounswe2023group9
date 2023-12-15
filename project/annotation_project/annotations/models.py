from django.db import models

class Source(models.Model):
    uri = models.URLField(max_length=100, unique=True)

class Selector(models.Model):
    type = models.CharField(max_length=100, default='TextPositionSelector')
    start = models.PositiveIntegerField()
    end = models.PositiveIntegerField()
    source = models.ForeignKey(Source)

class Body(models.Model):
    type = models.CharField(max_length=100, default='TextualBody')
    value = models.TextField(max_length=400)
    format = models.CharField(max_length=100, default='text/plain')
    language = models.CharField(max_length=100, default='en')

class Creator(models.Model):
    name = models.CharField(max_length=100)
    type = models.TextField(max_length=100, default='Person')

class Annotation(models.Model):
    type = models.CharField(max_length=100, default='Annotation')
    body = models.ForeignKey(Body)
    target = models.ForeignKey(Selector)
    creator = models.ForeignKey(Creator)
    created = models.DateTimeField(auto_now_add=True)
