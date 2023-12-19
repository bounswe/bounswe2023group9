import 'dart:convert';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminProvider with ChangeNotifier {
  Future<int> banUser(User? user, User? admin, bool isBanned) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': admin!.token,
    };

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/update_content_status/"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'context': "user",
            'content_id': user!.id.toString(),
            'hide': isBanned.toString()
          },
        ),
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> hideNode(User? admin, NodeDetailed node, bool isHidden) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': admin!.token,
    };

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/update_content_status/"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'context': "node",
            'content_id': node.nodeId.toString(),
            'hide': isHidden.toString()
          },
        ),
      );
      print(response.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> hideQuestion(User? admin, Question question, bool isHidden) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': admin!.token,
    };

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/update_content_status/"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'context': "question",
            'content_id': "-1", // TODO question!.id.toString().
            'hide': isHidden.toString()
          },
        ),
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> promoteUser(User? user, User? admin) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': admin!.token,
    };

    try {
      final response = await http.post(
        Uri.parse("${Constants.apiUrl}/promote_contributor/"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'cont_id': user!.id.toString(), //The basic user id of the contributor
          },
        ),
      );
      print(response.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> demoteUser(User? user, User? admin) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': admin!.token,
    };

    try {
      final response = await http.delete(
        Uri.parse("${Constants.apiUrl}/demote_reviewer/?${user!.id.toString()}"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'reviewer_id': user.id.toString(), //The basic user id of the reviewer
          },
        ),
      );
      print(response.statusCode);
    } catch (e) {
      rethrow;
    }
  }
}
