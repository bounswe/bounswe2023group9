from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class BasicUser(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.CharField(max_length=200, default="This user has not told about herself / himself yet...")
    email_notification_preference = models.BooleanField(default=False)
    show_activity_preference = models.BooleanField(default=True)

    def __str__(self):
        return self.user.first_name + " " + self.user.last_name
