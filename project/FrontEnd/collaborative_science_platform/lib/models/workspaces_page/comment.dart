import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';

class Comment {
  String comment;
  String reviewer;
  RequestStatus response;

  Comment({
    required this.comment,
    required this.reviewer,
    required this.response,
  });
  factory Comment.fromJson(Map<String, dynamic> jsonString) {
    String responseString = jsonString['response'];
    RequestStatus response;
    switch (responseString) {
      case 'A':
        response = RequestStatus.approved;
      case 'R':
        response = RequestStatus.rejected;
      default:
        response = RequestStatus.pending;
    }

    return Comment(
        comment: jsonString['comment'], reviewer: jsonString['reviewer'], response: response);
  }
}
