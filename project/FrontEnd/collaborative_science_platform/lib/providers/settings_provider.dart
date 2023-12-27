import 'dart:convert';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsProvider with ChangeNotifier {
  Future<int> changePassword(User? user, String oldPass, String newPass) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': "Token ${user!.token}",
    };
    final String body = json.encode({
      'old_password': oldPass,
      'password': newPass,
    });

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/change_password/"),
        headers: header,
        body: body,
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> changePreferences(
      User? user, String bio, bool sendNotification, bool showActivity, String orcid) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': "Token ${user!.token}",
    };
    final String body;
    if (orcid == "") {
      body = json.encode({
        'bio': bio,
        'email_notification_preference': sendNotification,
        'show_activity_preference': showActivity,
      });
    } else {
      body = json.encode({
        'bio': bio,
        'email_notification_preference': sendNotification,
        'show_activity_preference': showActivity,
        'orcid': orcid,
      });
    }
    try {
      final response = await http.put(Uri.parse("${Constants.apiUrl}/change_profile_settings/"),
          headers: header, body: body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
