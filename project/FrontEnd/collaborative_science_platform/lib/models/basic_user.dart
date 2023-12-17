class BasicUser {
  int basicUserId;
  String bio;
  bool emailNotificationPreference;
  bool showActivity;
  String userType;

  BasicUser({
    required this.basicUserId,
    required this.bio,
    required this.emailNotificationPreference,
    required this.showActivity,
    required this.userType,
  });
  factory BasicUser.fromJson(Map<String, dynamic> jsonString) {
    return BasicUser(
      basicUserId: jsonString["basic_user_id"],
      bio: jsonString["bio"],
      emailNotificationPreference: jsonString["email_notification_preference"],
      showActivity: jsonString["show_activity_preference"],
      userType: jsonString["user_type"],
    );
  }
}
