import 'dart:convert';

import 'package:collaborative_science_platform/exceptions/profile_page_exceptions.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileDataProvider with ChangeNotifier {
  ProfileData? profileData;

  Future<void> getData(String email) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_profile_info/?mail=$email");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        profileData = ProfileData(
          name: data['name'],
          surname: data['surname'],
          email: email,
          aboutMe: data['bio'],
          nodeIDs: data['nodes'] as List<int>,
          questionIDs: data['questions'] as List<int>,
        );
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw ProfileDoesNotExist();
      }
    } catch (error) {
      throw Exception("Error");
    }
  }
}
