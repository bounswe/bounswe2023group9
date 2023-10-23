class ProfileData {
  String name;
  String surname;
  String email;
  String aboutMe;
  List<int> nodeIDs;
  List<int> questionIDs;
  ProfileData(
      {this.aboutMe = "",
      this.email = "",
      this.name = "",
      this.surname = "",
      this.nodeIDs = const [],
      this.questionIDs = const []});
}
