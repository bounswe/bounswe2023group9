from django.db import models

class Source(models.Model):
    uri = models.URLField(max_length=100, unique=True)

class Selector(models.Model):
    type = models.CharField(max_length=100, default='TextPositionSelector')
    start = models.IntegerField()
    end = models.PositiveIntegerField()
    source = models.ForeignKey(Source, on_delete=models.CASCADE)

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
    body = models.ForeignKey(Body, on_delete=models.CASCADE)
    target = models.ForeignKey(Selector, on_delete=models.CASCADE)
    creator = models.ForeignKey(Creator, on_delete=models.PROTECT)
    created = models.DateTimeField(auto_now_add=True)
