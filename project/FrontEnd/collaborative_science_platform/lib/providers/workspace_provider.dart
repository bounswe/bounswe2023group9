import 'dart:convert';
import 'package:collaborative_science_platform/exceptions/workspace_exceptions.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkspaceProvider with ChangeNotifier {
  Workspaces? workspaces;
  Workspace? workspace;

  void clearAll() {
    workspace = null;
    workspaces = null;
  }

  Future<void> getUserWorkspaces(int id, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_user_workspaces/?user_id=$id");
    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        workspaces = Workspaces.fromJson(data);
        notifyListeners();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getWorkspaceById(int id, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/get_workspace/?workspace_id=$id");
    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        workspace = Workspace.fromJson(data);
        notifyListeners();
      } else if (response.statusCode == 404) {
        throw WorkspaceDoesNotExist();
      } else {
        throw Exception("Something has happened");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendCollaborationRequest(int senderId, int receiverId, String title,
      String requestBody, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/send_collab_req/");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'sender': senderId,
      'receiver': receiverId,
      'title': title,
      'body': requestBody,
      'workspace': workspaceId
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw SendCollaborationRequestException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRequest(int id, String status, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/update_req");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({'id': id, 'status': status});

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw SendCollaborationRequestException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createWorkspace(String title, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/workspace_post/?format=json");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_title': title,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw CreateWorkspaceException();
      } else if (response.statusCode == 403) {
        throw WorkspacePermissionException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> addSemanticTags(int id, String token, List<int> semanticTags) async {
    Uri url = Uri.parse("${Constants.apiUrl}/workspace_post/");

    final Map<String, String> headers = {
      "Authorization": token,
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_id': id,
      'semantic_tags': semanticTags,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw CreateWorkspaceException();
      } else if (response.statusCode == 403) {
        throw WorkspacePermissionException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateWorkspaceTitle(int id, String token, String title) async {
    Uri url = Uri.parse("${Constants.apiUrl}/workspace_post/");

    final Map<String, String> headers = {
      "Authorization": token,
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_id': id,
      'workspace_title': title,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw CreateWorkspaceException();
      } else if (response.statusCode == 403) {
        throw WorkspacePermissionException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReference(int workspaceId, int nodeId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/add_reference/");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_id': workspaceId,
      'node_id': nodeId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw AddReferenceException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addEntry(String content, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/add_entry/");
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      "workspace_id": "$workspaceId",
      'entry_content': content,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }

    // final Map<String, String> headers = {
    //   "Authorization": "Token $token",
    //   "Accept": "application/json",
    //   "content-type": "application/json"
    // };

    // final String body = json.encode({
    //   "workspace_id": workspaceId,
    //   'entry_content': content,
    // });
    // try {
    //   final response = await http.post(url, headers: headers, body: body);

    //   if (response.statusCode == 200) {
    //     notifyListeners();
    //   } else if (response.statusCode == 400) {
    //     throw AddEntryException();
    //   } else {
    //     throw Exception("Something has happened");
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<void> finalizeWorkspace(int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/finalize_workspace/");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_id': workspaceId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw FinalizeWorkspaceException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReference(int workspaceId, int nodeId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/delete_reference/");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_id': 9,
      'node_id': nodeId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw DeleteReferenceException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editEntry(String content, int entryId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/edit_entry/");
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      "entry_id": "$entryId",
      'content': content,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }

    // final Map<String, String> headers = {
    //   "Authorization": "Token $token",
    //   "Accept": "application/json",
    //   'Content-Type': 'application/json',
    // };

    // String body = json.encode({
    //   "entry_id": entryId,
    //   'content': content,
    // });
    // try {
    //   final response = await http.post(url, headers: headers, body: body);
    //   print(body);
    //   print("Create Response Body: ${response.body}");
    //   if (response.statusCode == 200) {
    //     notifyListeners();
    //   } else if (response.statusCode == 400) {
    //     throw EditEntryException();
    //   } else {
    //     throw Exception("Something has happened");
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<void> deleteEntry(int entryId, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/add_entry/");

    final Map<String, String> headers = {
      "Authorization": "Token $token",
      "content-type": "application/json"
    };

    final String body = json.encode({
      'workspace_id': workspaceId,
      'entry_id': entryId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw DeleteEntryException();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }
}
