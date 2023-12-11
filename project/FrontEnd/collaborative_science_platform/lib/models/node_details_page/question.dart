import 'package:collaborative_science_platform/models/user.dart';

class Question {
  String content;
  String createdAt;
  User? asker;
  String? answer;
  User? answerer;
  String? answeredAt;
  int? nodeId;
  Question({
    required this.content,
    required this.createdAt,
    required this.asker,
    required this.answer,
    required this.answerer,
    required this.answeredAt,
    required this.nodeId,
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
      nodeId: jsonString['node_id'] ?? -1,
    );
  }

  factory Question.fromJsonforProfilePage(Map<String, dynamic> jsonString) {
    return Question(
      content: jsonString['question_content'] ?? "",
      createdAt: jsonString['ask_date'] ?? "",
      asker: jsonString.containsKey("asker_id")
          ? User(
              id: jsonString['asker_id'],
              email: jsonString['asker_mail'],
              firstName: jsonString['asker_name'],
              lastName: jsonString['asker_surname'],
            )
          : null,
      answer: jsonString.containsKey("answer_content") ? jsonString["answer_content"] : "",
      answerer: jsonString.containsKey("answerer")
          ? User(
              id: jsonString['answerer_id'],
              email: jsonString['answerer_mail'],
              firstName: jsonString['answerer_name'],
              lastName: jsonString['answerer_surname'],
            )
          : null,
      answeredAt: jsonString.containsKey("answer_date") ? jsonString["answer_date"] as String : "",
      nodeId: jsonString['node_id'] ?? -1,
    );
  }
}
