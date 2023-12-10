import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/question_exceptions.dart';
import 'package:collaborative_science_platform/models/question.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionAnswerProvider with ChangeNotifier {
  final List<Question> _questions = [];

  List<Question> get questions {
    return [..._questions];
  }

  Future<void> postQuestion(String questionText, int nodeId) async {
    Uri url = Uri.parse("${Constants.apiUrl}/ask_question/");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    final Map<String, dynamic> postData = {
      "question_text": questionText,
      "node_id": nodeId,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _questions.add(Question(
          questionID: data['question_id'],
          askedBy: data['asked_by'],
          questionContent: data['question_content'],
          answer: data['answer_content'],
          publishDate: data['created_at'],
          respondedBy: data['responded_by'],
        ));
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw PostQuestionError();
      } else {
        throw Exception("Error posting question");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> postAnswer(String answerText, int questionId) async {
    Uri url = Uri.parse("${Constants.apiUrl}/answer_question/");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    final Map<String, dynamic> postData = {
      "answer_text": answerText,
      "question_id": questionId,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _questions.add(Question(
          questionID: data['question_id'],
          askedBy: data['asked_by'],
          questionContent: data['question_content'],
          answer: data['answer_content'],
          publishDate: data['created_at'],
          respondedBy: data['responded_by'],
        ));
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw PostQuestionError();
      } else {
        throw Exception("Error posting answer");
      }
    } catch (error) {
      rethrow;
    }
  }
}
