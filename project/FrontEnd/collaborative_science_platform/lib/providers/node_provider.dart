import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/node_details.exceptions.dart';
import 'package:collaborative_science_platform/exceptions/search_exceptions.dart';
import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NodeProvider with ChangeNotifier {
  final List<SmallNode> _searchNodeResult = [];
  NodeDetailed? nodeDetailed;

  void clearAll() {
    nodeDetailed = null;
  }

  List<SmallNode> get searchNodeResult {
    return [..._searchNodeResult];
  }

  Future<void> search(SearchType type, String query) async {
    _searchNodeResult.clear();
    if (type == SearchType.author) {
      throw WrongSearchTypeError();
    }
    String queryType = searchTypeToString[type]!;
    Uri url = Uri.parse("${Constants.apiUrl}/search/?query=$query&type=$queryType");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _searchNodeResult.addAll((data['nodes'] as List<dynamic>).map((node) => SmallNode(
              contributors: (node['authors'] as List<dynamic>)
                  .map((author) => Contributor(
                      name: author['name'], surname: author['surname'], email: author['username']))
                  .toList(),
              nodeId: node['id'],
              nodeTitle: node['title'],
              publishDate: DateTime.parse(node['date']),
            )));

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

Map<SearchType, String> searchTypeToString = {
  SearchType.theorem: "node",
  SearchType.author: "author",
  SearchType.by: "by",
  SearchType.both: "all"
};
