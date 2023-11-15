from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

from .views  import *

urlpatterns = [
    path('signup/', SignUpAPIView.as_view(), name='signup'),
    path('login/', obtain_auth_token, name='login'),
    path('get_authenticated_user/', UserDetailAPI.as_view(), name='get_authenticated_user'),
    path('get_node/', NodeAPIView.as_view(), name='get_node'),
    path('search/', search, name='search'),
    path('get_profile_info/', get_profile, name='get_profile'),
    path('change_password/', ChangePasswordView.as_view(), name='change_password'),
    path('change_profile_settings/', ChangeProfileSettingsView.as_view(), name='change_profile_settings'),
    path('get_proof/', get_proof_from_id, name='get_proof'),
    path('get_theorem/', get_theorem_from_id, name='get_theorem'),
    path('get_cont/', get_contributor_from_id, name='get_cont'),
    path('get_user_workspaces/',get_workspaces,name='get_user_workspaces'),
    path('get_workspace/',get_workspace_from_id,name='get_workspace'),
    path('send_collab_req/', send_collaboration_request, name='send_col_req'),
    path('update_req/', update_request_status, name='update_req'),
]
