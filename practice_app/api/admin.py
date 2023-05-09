from django.contrib import admin
from .models import Paper, Comment, Like, UserInterest, PaperList, FollowRequest, Follower
# Register your models here.

admin.site.register(Paper)
admin.site.register(Comment)
admin.site.register(Like)
admin.site.register(UserInterest)
admin.site.register(PaperList)
admin.site.register(FollowRequest)
admin.site.register(Follower)
