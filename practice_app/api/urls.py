from django.urls import path
from . import views

from django.views.generic import TemplateView




app_name = "api"
urlpatterns = [
    path('swagger-ui/', TemplateView.as_view(
        template_name='swagger-ui.html'
    ), name='swagger-ui'),
    path("doaj-api/", views.doaj_api, name="doaj_api"),
    path("google-scholar/", views.google_scholar, name="google-scholar"),
    path("core/", views.core_get, name="core"),
    path('eric/', views.eric_papers, name='eric_papers'),
    path("zenodo/",views.zenodo, name="zenodo"),
    path('semantic-scholar/', views.semantic_scholar, name='semantic-scholar'),
    path("nasa-sti/",views.nasa_sti, name="nasa-sti"),
    path("orcid-api/", views.orcid_api, name="orcid_api"),
    path("log-in/", views.log_in, name="log_in"),
    path("log-out/", views.log_out, name="log_out"),
    path("user-registration/", views.user_registration, name="user_registration"),
    path("follow-user/", views.follow_user, name="follow_user"),
    path('add-interest/',views.add_interest,name='add-interest'),
    path('post-papers/',views.post_papers,name='post-papers'),
    path('save-paper-list/', views.save_paper_list, name = 'save_paper_list'),
    path('add-paper-to-list/', views.add_paper_to_list, name="add_paper_to_list"),
    path('accept-follow-request/', views.accept_follow_request, name='accept_follow_request'),
    path('reject-follow-request/', views.reject_follow_request, name='reject_follow_request'),
    path('pubchem-api/', views.pubchem_api, name='pubchem_api'),
    path('create-paper-list/', views.create_paper_list , name="create-paper-list"),
    path('like-paper/',views.like_paper,name='like-paper'),
]
