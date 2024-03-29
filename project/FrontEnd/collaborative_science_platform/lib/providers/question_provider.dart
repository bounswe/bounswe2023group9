import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/question_exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionAnswerProvider with ChangeNotifier {
  final List<Question> _questions = [];

  List<Question> get questions {
    return [..._questions];
  }

  Future<void> postQuestion(String questionText, int nodeId, User user) async {
    Uri url = Uri.parse("${Constants.apiUrl}/ask_question/");

    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token ${user.token}",
    };
    final String body = json.encode({
      'question_content': questionText,
      'node_id': nodeId,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        _questions.add(Question(
            id: json.decode(response.body)['QuestionID'],
            answer: null,
            content: questionText,
            createdAt: DateTime.now().toString(),
            asker: user,
            answerer: null,
            answeredAt: null,
            nodeId: nodeId,
            isAnswered: false,
            isHidden: false));

        _questions
            .sort((a, b) => DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
        notifyListeners();
      } else if (response.statusCode == 401) {
        throw PostQuestionError();
      } else {
        throw Exception("Error posting question");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> postAnswer(String answerText, Question question, User user) async {
    Uri url = Uri.parse("${Constants.apiUrl}/answer_question/");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token ${user.token}",
    };
    final Map<String, dynamic> postData = {
      "answer_content": answerText,
      "question_id": question.id,
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(postData),
      );
      if (response.statusCode == 201) {
        question.isAnswered = true;
        question.answer = answerText;
        question.answeredAt = DateTime.now().toString();
        question.answerer = user;
        notifyListeners();
      } else if (response.statusCode == 403) {
        throw PostQuestionError();
      } else {
        throw Exception("Error posting answer");
      }
    } catch (error) {
      rethrow;
    }
  }
}
