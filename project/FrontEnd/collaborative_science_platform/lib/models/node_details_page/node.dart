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
  // factory Node.fromJson(Map<String, dynamic> jsonString) {
  //   var list = jsonString['authors'] as List;
  //   List<User> contributors = list.map((e) => User.fromJson(e)).toList();
  //   return Node(
  //       id: jsonString['id'],
  //       nodeTitle: jsonString['title'],
  //       publishDate: jsonString['date'],
  //       contributors: contributors);
  // }
}
