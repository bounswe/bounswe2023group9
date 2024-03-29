import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/models/workspace_semantic_tag.dart';

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
    var contributorList = jsonString['authors'] as List;
    List<User> contributors = contributorList.map((e) => User.fromJson(e)).toList();
    return Node(
      id: jsonString['id'],
      nodeTitle: jsonString['title'],
      publishDate: jsonString['date'],
      contributors: contributors,
    );
  }
}

class ProfileData {
  int id;
  String name;
  String surname;
  String email;
  String aboutMe;
  String orcid;
  List<Node> nodes;
  List<Question> askedQuestions;
  List<Question> answeredQuestions;
  String userType;
  bool isBanned;
  List<WorkspaceSemanticTag> tags;
  ProfileData({
    this.id = 0,
    this.aboutMe = "",
    this.email = "",
    this.name = "",
    this.surname = "",
    this.orcid = "",
    this.tags = const [],
    this.nodes = const [],
    this.askedQuestions = const [],
    this.answeredQuestions = const [],
    this.userType = "",
    this.isBanned = false,
  });

  factory ProfileData.fromJson(Map<String, dynamic> jsonString) {
    var nodeList = jsonString['nodes'] as List;
    var askedList = jsonString['asked_questions'] as List;
    var answeredList = jsonString['answered_questions'] as List;
    var tagList = jsonString['semantic_tags'] as List;

    List<Node> nodes = nodeList.map((e) => Node.fromJson(e)).toList();
    List<Question> asked = askedList.map((e) => Question.fromJsonforProfilePage(e)).toList();
    List<Question> answered = answeredList.map((e) => Question.fromJsonforProfilePage(e)).toList();
    List<WorkspaceSemanticTag> tags = tagList.map((e) => WorkspaceSemanticTag.fromJson(e)).toList();

    return ProfileData(
      id: jsonString['id'],
      name: jsonString['name'],
      surname: jsonString['surname'],
      aboutMe: jsonString['bio'],
      orcid: jsonString['orcid'] ?? "",
      nodes: nodes,
      askedQuestions: asked,
      answeredQuestions: answered,
      userType: jsonString['user_type'],
      isBanned: jsonString['is_banned'] ?? false,
      tags: tags,
    );
  }

  static getLoremIpsum(int id) {
    return ProfileData(
      name: "Lorem",
      surname: "Ipsum $id",
      email: "loremipsum$id@email.com",
      aboutMe:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      nodes: [
        Node(
          id: 1,
          nodeTitle: "Lorem Ipsum",
          publishDate: "01.01.2021",
          contributors: [
            User(
              firstName: "Lorem",
              lastName: "Ipsum $id",
              email: "loremipsum$id@email.com",
            ),
          ],
        ),
      ],
      tags: [],
    );
  }
}
