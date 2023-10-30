import 'dart:convert';

import 'package:collaborative_science_platform/exceptions/auth_exceptions.dart';
import 'package:collaborative_science_platform/exceptions/node_details.exceptions.dart';
import 'package:collaborative_science_platform/exceptions/profile_page_exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/models/theorem.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NodeDetailsProvider with ChangeNotifier {
  NodeDetailed? nodeDetailed;
  List<Proof> proof = [];
  Theorem? theorem;

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
}
