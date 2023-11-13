import 'dart:convert';

import 'package:collaborative_science_platform/exceptions/auth_exceptions.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  User? user;
  //User? user = User(email: "oma11r@omar.com", firstName: "omar", lastName: "uyduran");

  bool get isSignedIn {
    return user != null;
  }

  Future<void> login(String email, String password) async {
    Uri url = Uri.parse("${Constants.apiUrl}/login/");

    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'username': email, //kararlaştırılacak
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        Uri url = Uri.parse("${Constants.apiUrl}/get_authenticated_user/");
        final tokenHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Token ${data['token']}"
        };

        final tokenResponse = await http.get(url, headers: tokenHeaders);

        if (tokenResponse.statusCode == 200) {
          final userData = json.decode(tokenResponse.body);
          user = User(
              id: userData['id'],
              email: userData['email'],
              firstName: userData['first_name'],
              lastName: userData['last_name']);
        } else {
          throw Exception("Something has happened");
        }
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw WrongPasswordException(message: 'Your credentials are wrong');
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String name, String surname, String email, String password) async {
    Uri url = Uri.parse("${Constants.apiUrl}/signup/");

    final Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8'};

    final String body = json.encode({
      'username': email,
      'email': email,
      'first_name': name,
      'last_name': surname,
      'password': password,
      'password2': password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      user = User(
          // TODO: fix this
          id: data['id'],
          email: data['email'],
          firstName: data['first_name'],
          lastName: data['last_name']);
      try {
        await login(email, password);
      } catch (e) {
        throw Exception("Something has happened");
      }

      notifyListeners();
    } else if (response.statusCode == 400) {
      throw UserExistException(message: 'A user with that username already exists');
    } else {
      throw Exception("Something has happened");
    }
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
