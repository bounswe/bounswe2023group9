class ProfileDoesNotExist implements Exception {
  String message;
  ProfileDoesNotExist({this.message = "Profile Does Not Exist"});
}
