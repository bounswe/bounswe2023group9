class ProfileData {
  String name;
  String surname;
  String email;
  String aboutMe;
  List<int> nodeIDs;
  List<int> askedQuestionIDs;
  List<int> answeredQuestionIDs;

  ProfileData({
    this.aboutMe = "",
    this.email = "",
    this.name = "",
    this.surname = "",
    this.nodeIDs = const [],
    this.askedQuestionIDs = const [],
    this.answeredQuestionIDs = const [],
  });

  static getLoremIpsum(int id) {
    return ProfileData(
      name: "Lorem",
      surname: "Ipsum $id",
      email: "loremipsum$id@email.com",
      aboutMe: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      nodeIDs: [1, 2, 3, 4, 5],
      askedQuestionIDs: [1, 2, 3, 4, 5],
      answeredQuestionIDs: [1, 2, 3, 4, 5],
    );
  }
}
