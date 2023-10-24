import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/contributor_user.dart';

class Question {
  int questionID;
  BasicUser askedBy;
  String questionContent;
  String answer;
  DateTime publishDate;
  Contributor respondedBy;

  Question({
    required this.questionID,
    required this.askedBy,
    required this.questionContent,
    required this.answer,
    required this.publishDate,
    required this.respondedBy,
  });
}
