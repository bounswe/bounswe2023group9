import 'package:collaborative_science_platform/models/user.dart';

class Node {
  int id;
  String nodeTitle;
  DateTime publishDate;
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
        publishDate: DateTime.parse(jsonString['date']),
        contributors: contributors);
  }
  factory Node.fromJsonforNodeDetailPage(Map<String, dynamic> jsonString) {
    var list = jsonString['contributors'] as List;
    List<User> contributors = list.map((e) => User.fromJsonforNodeDetailPage(e)).toList();
    return Node(
        id: jsonString['node_id'],
        nodeTitle: jsonString['node_title'],
        publishDate: DateTime.parse(jsonString['date']),
        contributors: contributors);
  }
}
