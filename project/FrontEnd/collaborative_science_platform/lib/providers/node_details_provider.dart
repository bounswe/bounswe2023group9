import 'dart:convert';

import 'package:collaborative_science_platform/exceptions/auth_exceptions.dart';
import 'package:collaborative_science_platform/exceptions/node_details.exceptions.dart';
import 'package:collaborative_science_platform/exceptions/profile_page_exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/models/theorem.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NodeDetailsProvider with ChangeNotifier {
  NodeDetailed? nodeDetailed;
  List<Proof> proof = [];
  Theorem? theorem;
  List<NodeDetailed> references = [];
  List<NodeDetailed> citations = [];
  List<User> contributors = [];

  Future<void> getNode(int id) async {
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

        Uri url = Uri.parse(
            "${Constants.apiUrl}/get_theorem/?theorem_id=${nodeDetailed!.theorem}");
        try {
          final response = await http.get(url, headers: headers);
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            theorem = Theorem.fromJson(data);
          } else if (response.statusCode == 400) {
            throw TheoremDoesNotExist();
          } else {
            throw Exception("Something has happened");
          }
        } catch (error) {
          throw Exception("Error");
        }

        for (int i = 0; i < nodeDetailed!.proof.length; i++) {
          Uri url = Uri.parse(
              "${Constants.apiUrl}/get_proof/?proof_id=${nodeDetailed!.proof[i]}");
          try {
            final proofResponse = await http.get(url, headers: headers);
            if (proofResponse.statusCode == 200) {
              final data = json.decode(proofResponse.body);
              proof.add(Proof.fromJson(data));
            } else if (proofResponse.statusCode == 400) {
              throw ProofDoesNotExist();
            } else {
              throw Exception("Something has happened");
            }
          } catch (error) {
            throw Exception("Error");
          }
        }
        for (int i = 0; i < nodeDetailed!.references.length; i++) {
          Uri url = Uri.parse(
              "${Constants.apiUrl}/get_node/?node_id=${nodeDetailed!.references[i]}");
          final Map<String, String> headers = {
            "Accept": "application/json",
            "content-type": "application/json"
          };
          try {
            final referenceResponse = await http.get(url, headers: headers);
            if (referenceResponse.statusCode == 200) {
              final data = json.decode(referenceResponse.body);
              references.add(NodeDetailed.fromJson(data));
            } else if (referenceResponse.statusCode == 400) {
              throw NodeDoesNotExist();
            } else {
              throw Exception("Something has happened");
            }
          } catch (error) {
            throw Exception("Error");
          }
        }
        for (int i = 0; i < nodeDetailed!.citations.length; i++) {
          Uri url = Uri.parse(
              "${Constants.apiUrl}/get_node/?node_id=${nodeDetailed!.citations[i]}");
          final Map<String, String> headers = {
            "Accept": "application/json",
            "content-type": "application/json"
          };
          try {
            final citationsResponse = await http.get(url, headers: headers);
            if (citationsResponse.statusCode == 200) {
              final data = json.decode(citationsResponse.body);
              citations.add(NodeDetailed.fromJson(data));
            } else if (citationsResponse.statusCode == 400) {
              throw NodeDoesNotExist();
            } else {
              throw Exception("Something has happened");
            }
          } catch (error) {
            throw Exception("Error");
          }
        }
        for (int i = 0; i < nodeDetailed!.contributors.length; i++) {
          Uri url = Uri.parse(
              "${Constants.apiUrl}/get_cont/?id=${nodeDetailed!.contributors[i]}");
          final Map<String, String> headers = {
            "Accept": "application/json",
            "content-type": "application/json"
          };
          try {
            final contributorsResponse = await http.get(url, headers: headers);
            if (contributorsResponse.statusCode == 200) {
              final data = json.decode(contributorsResponse.body);
              contributors.add(User.fromJson(data));
            } else if (contributorsResponse.statusCode == 400) {
              throw NodeDoesNotExist();
            } else {
              throw Exception("Something has happened");
            }
          } catch (error) {
            throw Exception("Error");
          }
        }

        notifyListeners();
      } else if (response.statusCode == 400) {
        throw NodeDoesNotExist();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      throw Exception("Error");
    }
  }

  Future<void> getProof(int id) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_proof/?proof_id=$id");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        proof.add(Proof.fromJson(data));
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw ProofDoesNotExist();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      throw Exception("Error");
    }
  }

  Future<void> getTheorem(int id) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_proof/?theorem_id=$id");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //theorem = Theorem.fromJson(data);
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw TheoremDoesNotExist();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      throw Exception("Error");
    }
  }

  Future<void> getUser(int id) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_proof/?user_id=$id");
    final Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        notifyListeners();
      } else if (response.statusCode == 400) {
        throw UserExistException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      throw Exception("Error");
    }
  }

  Future<void> getReferences(List<int> ids) async {
    for (int i = 0; i < nodeDetailed!.references.length; i++) {
      Uri url = Uri.parse(
          "${Constants.apiUrl}/get_node/?node_id=${nodeDetailed!.references[i]}");
      final Map<String, String> headers = {
        "Accept": "application/json",
        "content-type": "application/json"
      };
      try {
        final referenceResponse = await http.get(url, headers: headers);
        if (referenceResponse.statusCode == 200) {
          final data = json.decode(referenceResponse.body);
          references.add(NodeDetailed.fromJson(data));
        } else if (referenceResponse.statusCode == 400) {
          throw NodeDoesNotExist();
        } else {
          throw Exception("Something has happened");
        }
      } catch (error) {
        throw Exception("Error");
      }
    }
    notifyListeners();
  }

  Future<void> getCitations(List<int> ids) async {
    for (int i = 0; i < nodeDetailed!.citations.length; i++) {
      Uri url = Uri.parse(
          "${Constants.apiUrl}/get_node/?node_id=${nodeDetailed!.citations[i]}");
      final Map<String, String> headers = {
        "Accept": "application/json",
        "content-type": "application/json"
      };
      try {
        final citationsResponse = await http.get(url, headers: headers);
        if (citationsResponse.statusCode == 200) {
          final data = json.decode(citationsResponse.body);
          citations.add(NodeDetailed.fromJson(data));
        } else if (citationsResponse.statusCode == 400) {
          throw NodeDoesNotExist();
        } else {
          throw Exception("Something has happened");
        }
      } catch (error) {
        throw Exception("Error");
      }
    }
    notifyListeners();
  }
}
