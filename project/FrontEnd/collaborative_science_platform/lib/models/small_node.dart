
import 'package:collaborative_science_platform/models/account.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/contributor_user.dart';

class SmallNode {
  int nodeId;
  String nodeTitle;
  List<String> contributors;
  String theorem;
  DateTime publishDate;

  SmallNode({
    required this.nodeId,
    required this.nodeTitle,
    required this.contributors,
    required this.theorem,
    required this.publishDate,
  });

  static SmallNode getLoremIpsum(int id) {
    return SmallNode(
      nodeId: 0,
      nodeTitle: "Lorem Ipsum $id",
      contributors: ["Marcus Tullius Cicero", "Jesus Christ", "Remus", "Romulus", "Julius Caesar"],
      theorem: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      publishDate: DateTime(1989, 10, 29, 8, 0, 0),
    );
  }
}
