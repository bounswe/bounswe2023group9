from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

from .views  import *
from django.views.generic import TemplateView


urlpatterns = [
    path('docs/', TemplateView.as_view(
        template_name='swagger-ui.html'
    ), name='swagger-ui'),
    path('signup/', SignUpAPIView.as_view(), name='signup'),
    path('login/', obtain_auth_token, name='login'),
    path('get_authenticated_user/', UserDetailAPI.as_view(), name='get_authenticated_user'),
    path('get_authenticated_basic_user/', BasicUserDetailAPI.as_view(), name='get_authenticated_basic_user'),
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
    path('edit_entry/', edit_entry, name='edit_entry'),
    path('delete_entry/',delete_entry,name='delete_entry'),
    path('add_entry/',add_entry,name='add_entry'),
    path('get_random_node_id/',get_random_node_id,name='get_random_node_id'),
    path('create_workspace/',create_workspace,name='create_workspace'),
    path('workspace_post/', WorkspacePostAPIView.as_view(), name='workspace_post'),
    path('add_reference/',add_reference,name='add_reference'),
    path('finalize_workspace/',finalize_workspace,name='finalize_workspace'),
    path('delete_contributor/',delete_contributor,name='delete_contributor'),
    path('delete_workspace/',delete_workspace,name='delete_workspace'),
    path('delete_contributor/',delete_contributor,name='delete_contributor'),
    path('delete_reference/', delete_reference, name='delete_reference'),
    path('send_collab_req/', send_collaboration_request, name='send_col_req'),
    path('update_collab_req/', update_collab_request_status, name='update_collab_req'),
    path('update_review_req/', update_review_request_status, name='update_review_req'),
    path('send_rev_req/', send_review_request, name='send_rev_req'),
    path('get_semantic_suggestion/', get_semantic_suggestion, name='get_semantic_suggestion'),
    path('ask_question/', AskQuestion.as_view(), name='ask_question'),
    path('answer_question/', AnswerQuestion.as_view(), name='answer_question'),
    path('update_content_status/', update_content_status, name='update_content_status'),
    path('set_workspace_theorem/', set_workspace_theorem, name='set_workspace_theorem'),
    path('set_workspace_proof/', set_workspace_proof, name='set_workspace_proof'),
    path('set_workspace_disproof/', set_workspace_disproof, name='set_workspace_disproof'),
    path('remove_workspace_theorem/', remove_workspace_theorem, name='remove_workspace_theorem'),
    path('remove_workspace_proof/', remove_workspace_proof, name='remove_workspace_proof'),
    path('remove_workspace_disproof/', remove_workspace_disproof, name='remove_workspace_disproof'),
    path('change_workspace_title/', change_workspace_title, name='change_workspace_title'),
    path('promote_contributor/', promote_contributor, name='promote_contributor'),
    path('demote_reviewer/', demote_reviewer, name='demote_reviewer'),
    path('add_user_semantic_tag/', AddUserSemanticTag.as_view(), name='add_user_semantic_tag'),
    path('add_semantic_tag/', SemanticTagAPIView.as_view(), name='add_semantic_tag'),
    path('remove_workspace_tag/', remove_workspace_tag, name='remove_workspace_tag'),
    path('remove_user_tag/', remove_user_tag, name='remove_user_tag'),
    path('get_related_nodes/', get_related_nodes, name='get_related_nodes'),
    path('reset_workspace_state/', reset_workspace_state, name='reset_workspace_state'),


]
