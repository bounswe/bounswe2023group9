//This provider is for user type

import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/search_exceptions.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BasicUserProvider with ChangeNotifier {
  BasicUser? basicUser;

  Future<void> getData(String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_authenticated_basic_user/");
    final Map<String, String> headers = {
      "Authorization": token,
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        basicUser = BasicUser.fromJson(data);
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw SearchError();
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      rethrow;
    }
  }
}

/*{
    "basic_user_id": 92,
    "bio": "Administrator",
    "email_notification_preference": false,
    "show_activity_preference": true,
    "user_type": "admin"
}*/