import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/search_exceptions.dart';
import 'package:collaborative_science_platform/models/search_result.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  SearchResult? searchResult;

  Future<void> search(SearchType type, String query) async {
    String queryType = searchTypeToString[type]!;
    Uri url =
        Uri.parse("${Constants.apiUrl}/search/?query=$query&type=$queryType");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        searchResult = SearchResult(
            nodes: (data['nodes'] as List<dynamic>)
                .map((node) => NodeResult(
                      id: node['id'],
                      title: node['title'],
                      date: node['date'],
                      authors: (node['authors'] as List<dynamic>)
                          .map((author) => AuthorResult(
                                name: author['name'],
                                surname: author['surname'],
                                username: author['username'],
                              ))
                          .toList(),
                    ))
                .toList(),
            authors: (data['authors'] as List<dynamic>)
                .map((author) => AuthorResult(
                      name: author['name'],
                      surname: author['surname'],
                      username: author['username'],
                    ))
                .toList());
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

Map<SearchType, String> searchTypeToString = {
  SearchType.theorem: "node",
  SearchType.author: "author",
  SearchType.by: "by",
  SearchType.both: "all"
};
