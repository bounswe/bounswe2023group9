import 'package:collaborative_science_platform/models/user.dart';

class Question {
  int id;
  String content;
  String createdAt;
  User asker;
  String? answer;
  String? url;
  User? answerer;
  String? answeredAt;
  int? nodeId;
  bool isAnswered;
  bool isHidden;
  Question(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.asker,
      required this.answer,
      required this.answerer,
      required this.answeredAt,
      required this.nodeId,
      required this.isAnswered,
      required this.isHidden,
      this.url});
  factory Question.fromJson(Map<String, dynamic> jsonString) {
    return Question(
      id: jsonString['id'] ?? -1,
      content: jsonString['question_content'] ?? "",
      createdAt: jsonString['created_at'] ?? "",
      answer: jsonString['answer_content'] ?? "",
      answeredAt: jsonString['answered_at'] ?? "",
      answerer: jsonString['answerer'] == null
          ? null
          : User.fromJsonforNodeDetailPage(jsonString['answerer']),
      asker: User.fromJsonforNodeDetailPage(jsonString['asker']),
      nodeId: jsonString['node_id'] ?? -1,
      url: jsonString['url'] ?? "",
      isAnswered: jsonString['answer_content'] != null,
      isHidden: jsonString['removed_by_admin'] ?? false,
    );
  }

  factory Question.fromJsonforProfilePage(Map<String, dynamic> jsonString) {
    return Question(
      id: jsonString['id'] ?? -1,
      content: jsonString['question_content'] ?? "",
      createdAt: jsonString['ask_date'] ?? "",
      asker: User(
        id: jsonString['asker_id'],
        email: jsonString['asker_mail'],
        firstName: jsonString['asker_name'],
        lastName: jsonString['asker_surname'],
      ),
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
      url: jsonString['image_url'] ?? "",
      isAnswered: jsonString['is_answered'] == 1,
      isHidden: jsonString['removed_by_admin'] ?? false,
    );
  }
}
