from django.db import models

class Annotation(models.Model):
    context = models.CharField(max_length=100)
    id = models.CharField(max_length=100, primary_key=True)
    type = 'Annotation'
    body = models.TextField(max_length=500)
    target_source = models.URLField() #How should we decide?
    target_selector_type = 'TextPositionSelector'
    target_selector_start = models.PositiveIntegerField()
    target_selector_end = models.PositiveIntegerField()

        

