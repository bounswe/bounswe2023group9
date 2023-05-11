from django.urls import path
from . import views

from django.views.generic import TemplateView




app_name = "api"
urlpatterns = [
    path('swagger-ui/', TemplateView.as_view(
        template_name='swagger-ui.html'
    ), name='swagger-ui'),
    path("doaj-api/", views.doaj_get, name="doaj_api"),
    path("google-scholar/", views.google_scholar, name="google-scholar"),
    path("core/", views.core_get, name="core"),
    path('eric/', views.eric_papers, name='eric_papers'),
    path("zenodo/",views.zenodo, name="zenodo"),
    path('semantic-scholar/', views.semantic_scholar, name='semantic-scholar'),
    path("orcid_api/", views.orcid_api, name="orcid_api"),
    path("log_in/", views.log_in, name="log_in"),
    path("log_out/", views.log_out, name="log_out"),
    path("user_registration/", views.user_registration, name="user_registration"),
    path("follow_user/", views.follow_user, name="follow_user"),
    path('post-papers/',views.post_papers,name='post-papers'),
]
