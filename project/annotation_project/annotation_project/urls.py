from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('annotations/', include("annotations.urls")) # url must start with 'annotations/' according to the standard: https://www.w3.org/TR/annotation-protocol/#:~:text=5.2%20Suggesting%20an%20IRI%20for%20an%20Annotation
]
