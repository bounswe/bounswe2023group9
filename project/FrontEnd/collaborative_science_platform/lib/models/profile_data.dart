import 'package:collaborative_science_platform/models/user.dart';

class Node {
  int id;
  String nodeTitle;
  String publishDate;
  List<User> contributors;
  Node({
    required this.contributors,
    required this.id,
    required this.nodeTitle,
    required this.publishDate,
  });
  factory Node.fromJson(Map<String, dynamic> jsonString) {
    var list = jsonString['authors'] as List;
    List<User> contributors = list.map((e) => User.fromJson(e)).toList();
    return Node(
        id: jsonString['id'],
        nodeTitle: jsonString['title'],
        publishDate: jsonString['date'],
        contributors: contributors);
  }
}

class ProfileData {
  String name;
  String surname;
  String email;
  String aboutMe;
  List<Node> nodes;
  List<int> askedQuestionIDs;
  List<int> answeredQuestionIDs;
  ProfileData(
      {this.aboutMe = "",
      this.email = "",
      this.name = "",
      this.surname = "",
      this.nodes = const [],
      this.askedQuestionIDs = const [],
      this.answeredQuestionIDs = const []});
  factory ProfileData.fromJson(Map<String, dynamic> jsonString) {
    var list = jsonString['nodes'] as List;
    List<Node> nodes = list.map((e) => Node.fromJson(e)).toList();
    return ProfileData(
      nodes: nodes,
      name: jsonString['name'],
      surname: jsonString['surname'],
      aboutMe: jsonString['bio'],
    );
  }
}
