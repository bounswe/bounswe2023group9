class ProfileData {
  String name;
  String surname;
  String email;
  String aboutMe;
  List<int> nodeIDs;
  List<int> askedQuestionIDs;
  List<int> answeredQuestionIDs;
  ProfileData(
      {this.aboutMe = "",
      this.email = "",
      this.name = "",
      this.surname = "",
      this.nodeIDs = const [],
      this.askedQuestionIDs = const [],
      this.answeredQuestionIDs = const []});
}
