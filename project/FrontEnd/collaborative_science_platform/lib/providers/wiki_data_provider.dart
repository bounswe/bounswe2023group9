import 'dart:convert';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:collaborative_science_platform/utils/constants.dart';

class WikiDataProvider with ChangeNotifier {
  List<SemanticTag> tags = [];

  Future<void> wikiDataSearch(String query, int maxLength) async {
    Uri url = Uri.parse("https://www.wikidata.org/w/api.php?action=wbsearchentities&language=en&format=json&search=$query");
    Map header = {

    };
    final http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)["search"];
        final int length = (data.length < maxLength) ? data.length : maxLength;

        tags.clear();
        tags = List.generate(
          length, (index) => SemanticTag(
            id: data[index]["id"],
            label: data[index]["display"]["label"]["value"],
            description: data[index]["display"]["description"]["value"],
          ),
        );
        notifyListeners();
      } else {
        throw Exception("An error occurred: ${response.statusCode}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addSemanticTag(String wikiId, String label, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/add_semantic_tag/");
    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'wiki_id': wikiId,
      'label': label,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception("Something has gone wrong");
    }
  }

  Future<void> deleteSemanticTag(String wikiId, String label, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/delete_semantic_tag/");
    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'wiki_id': wikiId,
      'label': label,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception("Something has gone wrong");
    }
  }
}