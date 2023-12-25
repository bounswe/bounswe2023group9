import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/node_details_exceptions.dart';
import 'package:collaborative_science_platform/exceptions/search_exceptions.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NodeProvider with ChangeNotifier {
  final List<Node> _searchNodeResult = [];
  final List<Node> _youMayLikeNodeResult = [];
  NodeDetailed? nodeDetailed;

  final List<SemanticTag> semanticTags = [];

  void clearAll() {
    nodeDetailed = null;
  }

  List<Node> get searchNodeResult {
    return [..._searchNodeResult];
  }

  List<Node> get youMayLikeNodeResult {
    return [..._youMayLikeNodeResult];
  }

  SemanticTag getSemanticTag(String label) {
    return semanticTags.firstWhere((element) => element.label == label);
  }

  Future<void> search(SearchType type, String query,
      {bool random = false, bool semantic = false}) async {
    if (type == SearchType.author) {
      throw WrongSearchTypeError();
    }
    String queryType = searchTypeToString[type]!;
    if (random) {
      queryType = "random";
    }
    if (semantic) {
      queryType = "semantic";
    }
    Uri url = Uri.parse("${Constants.apiUrl}/search/?query=$query&type=$queryType");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _searchNodeResult.clear();
        _searchNodeResult.addAll((data['nodes'] as List<dynamic>).map((node) => Node(
              contributors: (node['authors'] as List<dynamic>)
                  .map((author) => User(
                      id: author['id'],
                      firstName: author['name'],
                      lastName: author['surname'],
                      email: author['username']))
                  .toList(),
              id: node['id'],
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

  Future<void> semanticSuggestions(String keyword) async {
    semanticTags.clear();
    Uri url = Uri.parse("${Constants.apiUrl}/get_semantic_suggestion/?keyword=$keyword");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _youMayLikeNodeResult.clear();
        _youMayLikeNodeResult.addAll((data['nodes'] as List<dynamic>).map((node) => Node(
              contributors: (node['authors'] as List<dynamic>)
                  .map((author) => User(
                      id: author['id'],
                      firstName: author['name'],
                      lastName: author['surname'],
                      email: author['username']))
                  .toList(),
              id: node['id'],
              nodeTitle: node['title'],
              publishDate: DateTime.parse(node['date']),
            )));
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw SearchError();
      } else {
        if (json.decode(response.body)["message"] == "There are no nodes with this semantic tag.") {
          throw SearchError();
        }
        throw Exception("Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getRelatedNodes(int nodeId) async {
    _youMayLikeNodeResult.clear();
    Uri url = Uri.parse("${Constants.apiUrl}/get_related_nodes/?node_id=$nodeId");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        data = data["nodes"];
        for (var element in data) {
          _youMayLikeNodeResult.add(Node.fromJson(element));
        }
      } else if (response.statusCode == 400) {
        throw SearchError();
      } else {
        if (json.decode(response.body)["message"] == "There are no nodes with this semantic tag.") {
          throw SearchError();
        }
        throw Exception("Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getNode(int id, String token) async {
    clearAll();
    Uri url = Uri.parse("${Constants.apiUrl}/get_node/");
    if (id > -1) {
      url = Uri.parse("${Constants.apiUrl}/get_node/?node_id=$id");
    }

    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };

    if (token.isNotEmpty) {
      headers.addAll({"Authorization": "Token $token"});
    }

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

  Future<void> getNodeByType(String queryType) async {
    Uri url = Uri.parse("${Constants.apiUrl}/search/?type=$queryType");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _searchNodeResult.clear();
        _searchNodeResult.addAll((data['nodes'] as List<dynamic>).map((node) => Node(
              contributors: (node['authors'] as List<dynamic>)
                  .map((author) => User(
                      id: author['id'],
                      firstName: author['name'],
                      lastName: author['surname'],
                      email: author['username']))
                  .toList(),
              id: node['id'],
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

  Map<SearchType, String> searchTypeToString = {
    SearchType.theorem: "node",
    SearchType.author: "author",
    SearchType.by: "by",
    SearchType.both: "all"
  };
}
