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
    path('change_password/', ChangePasswordView.as_view(), name='change_password')
]
