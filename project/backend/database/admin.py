from django.contrib import admin
from .models import *

# Register your models here.

admin.site.register(BasicUser)
admin.site.register(Contributor)
admin.site.register(Reviewer)
admin.site.register(Theorem)
admin.site.register(Workspace)
admin.site.register(Request)
admin.site.register(Annotation)
admin.site.register(Node)
admin.site.register(Proof)
