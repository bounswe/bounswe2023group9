from django.contrib import admin
from .models import *

# Register your models here.

admin.site.register(Workspace)
admin.site.register(Entry)
admin.site.register(BasicUser)
admin.site.register(Contributor)
admin.site.register(Reviewer)
admin.site.register(Theorem)
admin.site.register(SemanticTag)
admin.site.register(Node)
admin.site.register(Proof)
admin.site.register(Question)
admin.site.register(WikiTag)
admin.site.register(Annotation)
admin.site.register(Request)
