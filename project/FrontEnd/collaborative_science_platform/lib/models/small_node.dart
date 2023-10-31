import 'package:collaborative_science_platform/models/contributor_user.dart';

class SmallNode {
  int nodeId;
  String nodeTitle;
  List<Contributor> contributors;
  DateTime publishDate;

  SmallNode({
    required this.nodeId,
    required this.nodeTitle,
    required this.contributors,
    required this.publishDate,
  });

  static SmallNode getLoremIpsum(int id) {
    return SmallNode(
      nodeId: 0,
      nodeTitle: "Lorem Ipsum $id",
      contributors: [
        Contributor(
            name: "Marcus", surname: "Tullius", email: "Marcus@email.com"),
        Contributor(
            name: "Abdullah", surname: "Susuz", email: "abdullah@email.com")
      ],
      //theorem:
      //    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      publishDate: DateTime(1989, 10, 29, 8, 0, 0),
    );
  }
}
