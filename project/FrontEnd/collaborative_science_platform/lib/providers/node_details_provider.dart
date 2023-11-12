import 'dart:convert';

import 'package:collaborative_science_platform/exceptions/node_details.exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NodeDetailsProvider with ChangeNotifier {
  NodeDetailed? nodeDetailed;
  void clearAll() {
    nodeDetailed = null;
  }

  Future<void> getNode(int id) async {
    clearAll();
    Uri url = Uri.parse("${Constants.apiUrl}/get_node/?node_id=$id");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        nodeDetailed = NodeDetailed.fromJson(data);
        notifyListeners();
      } else if (response.statusCode == 404) {
        throw NodeDoesNotExist();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      rethrow;
    }
  }
}
