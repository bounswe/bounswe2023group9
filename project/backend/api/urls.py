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
    path('delete_entry/',delete_entry,name='delete_entry'),
    path('add_entry/',add_entry,name='add_entry'),
    path('get_random_node_id/',get_random_node_id,name='get_random_node_id'),
    path('create_workspace/',create_workspace,name='create_workspace'),
    path('add_reference/',add_reference,name='add_reference'),
    path('finalize_workspace/',finalize_workspace,name='finalize_workspace'),
    path('delete_contributor/',delete_contributor,name='delete_contributor'),
    path('delete_workspace/',delete_workspace,name='delete_workspace'),
    path('delete_contributor/',delete_contributor,name='delete_contributor'),
    path('delete_reference/', delete_reference, name='delete_reference'),
    path('send_collab_req/', send_collaboration_request, name='send_col_req'),
    path('update_req/', update_request_status, name='update_req'),
    path('send_rev_req/', send_review_request, name='send_rev_req'),
]
