class BasicUser {
  int basicUserId;
  String bio;
  bool emailNotificationPreference;
  bool showActivity;
  String userType;

  BasicUser({
    this.basicUserId = 0,
    this.bio = "",
    this.emailNotificationPreference = true,
    this.showActivity = true,
    this.userType = "",
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
