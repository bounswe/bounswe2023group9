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
      'Authorization': "Token"// ${user!.token}",
    };

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/change_password/"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'old_password': oldPass,
            'new_password': newPass,
          },
        ),
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePreferences(User? user, String bio, bool sendNotification, bool showActivity) async {
    final Map<String, String> header = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': "Token"// ${user!.token}",
    };

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiUrl}/change_profile_settings/"),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'bio': bio,
            'email_notification_preference': sendNotification.toString(),
            'show_activity_preference': showActivity.toString()
          },
        ),
      );
      print(response.statusCode);
    } catch (e) {
      rethrow;
    }
  }
}
