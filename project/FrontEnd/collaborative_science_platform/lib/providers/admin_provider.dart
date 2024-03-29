import 'dart:convert';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminProvider with ChangeNotifier {
  Future<int> banUser(User? admin, int userId, bool isBanned) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': "Token ${admin!.token}",
    };
    final String body = json.encode({
      'context': "user",
      'content_id': userId,
      'hide': isBanned,
    }); 
    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/update_content_status/"),
        headers: header,
        body: body,
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
      'Authorization': "Token ${admin!.token}",
    };
    final String body = json.encode({
      'context': "node",
      'content_id': node.nodeId,
      'hide': isHidden,
    });
    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/update_content_status/"),
        headers: header,
        body: body,
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
      'Authorization': "Token ${admin!.token}",
    };
    final String body = json.encode({
      'context': "question",
      'content_id': question.id,
      'hide': isHidden,
    });
    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/update_content_status/"),
        headers: header,
        body: body,
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> promoteUser(User? admin, int userId) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': "Token ${admin!.token}",
    };
    final String body = json.encode({'cont_id': userId});
    try {
      final response = await http.post(Uri.parse("${Constants.apiUrl}/promote_contributor/"),
          headers: header, body: body);

      if (response.statusCode == 200) {
        print("User is promoted to reviewer.");
      }
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> demoteUser(User? admin, int userId) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': "Token ${admin!.token}",
    };
    try {
      final response = await http.delete(
          Uri.parse("${Constants.apiUrl}/demote_reviewer/?reviewer_id=${userId.toString()}"),
          headers: header);
      if (response.statusCode == 200) {
        print("User is demoted to contributor.");
      }
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
