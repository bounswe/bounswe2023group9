import 'package:collaborative_science_platform/models/user.dart';

class Question {
  String content;
  String createdAt;
  User? asker;
  String answer;
  User? answerer;
  String answeredAt;
  Question({
    required this.content,
    required this.createdAt,
    required this.answer,
    required this.answeredAt,
    required this.answerer,
    required this.asker,
  });
  factory Question.fromJson(Map<String, dynamic> jsonString) {
    return Question(
      content: jsonString['question_content'] ?? "",
      createdAt: jsonString['created_at'] ?? "",
      answer: jsonString['answer_content'] ?? "",
      answeredAt: jsonString['answered_at'] ?? "",
      answerer: jsonString['answerer'] == null
          ? null
          : User.fromJsonforNodeDetailPage(jsonString['answerer']),
      asker:
          jsonString['asker'] == null ? null : User.fromJsonforNodeDetailPage(jsonString['asker']),
    );
  }
}
