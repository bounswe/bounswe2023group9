import 'dart:convert';

import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  User? user;

  bool get isAuth {
    return user != null;
  }

  Future<void> login(String email, String password) async {
    Uri url = Uri.parse("${Constants.apiUrl}/login");
    final Map<String, String> headers = {};

    try {
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);

      user = User(
        name: data['name'],
        email: data['email'],
        token: data['token'],
      );

      notifyListeners();
    } catch (error) {
      throw Exception("Error");
    }
  }

  Future<void> signup(String name, String email, String password) async {}

  Future<void> logout() async {}
}
