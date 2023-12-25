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

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'sender': "$senderId",
      'receiver': "$receiverId",
      'title': title,
      'body': requestBody,
      'workspace': "$workspaceId"
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw SendCollaborationRequestException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> updateRequest(int id, RequestStatus status, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/update_req");

    String requestStatus = "";
    if (status == RequestStatus.approved) {
      requestStatus = "A";
    } else if (status == RequestStatus.rejected) {
      requestStatus = "R";
    } else {
      requestStatus = "P";
    }

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'id': "$id",
      'status': requestStatus,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw SendCollaborationRequestException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> updateReviewRequest(int id, RequestStatus status, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/update_review_req/");

    String requestStatus = "";
    if (status == RequestStatus.approved) {
      requestStatus = "A";
    } else if (status == RequestStatus.rejected) {
      requestStatus = "R";
    } else {
      requestStatus = "P";
    }

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'id': "$id",
      'status': requestStatus,
      'comment': "OK",
    });
    print(request.fields);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    print(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw SendCollaborationRequestException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> updateCollaborationRequest(int id, RequestStatus status, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/update_collab_req/");
    String requestStatus = "";
    if (status == RequestStatus.approved) {
      requestStatus = "A";
    } else if (status == RequestStatus.rejected) {
      requestStatus = "R";
    } else {
      requestStatus = "P";
    }

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'id': "$id",
      'status': requestStatus,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw SendCollaborationRequestException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> createWorkspacefromNode(int nodeId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/create_workspace/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'node_id': "$nodeId",
      'workspace_title': " ",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw CreateWorkspaceException();
    } else if (response.statusCode == 403) {
      throw WorkspacePermissionException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> createWorkspace(String title, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/workspace_post/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_title': title,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw CreateWorkspaceException();
    } else if (response.statusCode == 403) {
      throw WorkspacePermissionException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> addSemanticTags(int id, String token, List<int> semanticTags) async {
    Uri url = Uri.parse("${Constants.apiUrl}/workspace_post/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "workspace_id": "$id",
      'semantic_tags': "$semanticTags", // check if the data converted correctly
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw CreateWorkspaceException();
    } else if (response.statusCode == 403) {
      throw WorkspacePermissionException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> updateWorkspaceTitle(int id, String token, String title) async {
    Uri url = Uri.parse("${Constants.apiUrl}/workspace_post/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "workspace_id": "$id",
      'workspace_title': title,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw CreateWorkspaceException();
    } else if (response.statusCode == 403) {
      throw WorkspacePermissionException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> addReference(int workspaceId, int nodeId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/add_reference/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "workspace_id": "$workspaceId",
      'node_id': "$nodeId",
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw AddReferenceException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> addEntry(String content, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/add_entry/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "workspace_id": "$workspaceId",
      'entry_content': content,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw AddEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> finalizeWorkspace(int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/finalize_workspace/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw FinalizeWorkspaceException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> sendWorkspaceToReview(int workspaceId, int userId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/send_rev_req/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace': "$workspaceId",
      'sender': "$userId",
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw FinalizeWorkspaceException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> deleteReference(int workspaceId, int nodeId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/delete_reference/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
      'node_id': "$nodeId",
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw DeleteReferenceException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> editEntry(String content, int entryId, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/edit_entry/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "entry_id": "$entryId",
      'workspace_id': "$workspaceId",
      'content': content,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> deleteEntry(int entryId, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/delete_entry/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
      'entry_id': "$entryId",
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw DeleteEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> addReview(int id, RequestStatus status, String comment, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/update_review_req/");

    String requestStatus = "";
    if (status == RequestStatus.approved) {
      requestStatus = "A";
    } else if (status == RequestStatus.rejected) {
      requestStatus = "R";
    } else {
      requestStatus = "P";
    }

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'id': "$id",
      'comment': comment,
      'response': requestStatus,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw DeleteEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }


    Future<void> resetWorkspace(int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/reset_workspace_state/");

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw WorkspaceDoesNotExist();
    } else {
      throw Exception("Something has happened");
    }
  }

 Future<void> setProof(int entryId, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/set_workspace_proof/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "entry_id": "$entryId",
      'workspace_id': "$workspaceId",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> setDisproof(int entryId, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/set_workspace_disproof/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "entry_id": "$entryId",
      'workspace_id': "$workspaceId",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> removeProof(int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/remove_workspace_proof/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> removeDisproof(int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/remove_workspace_disproof/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> setTheorem(int entryId, int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/set_workspace_theorem/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      "entry_id": "$entryId",
      'workspace_id': "$workspaceId",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }

  Future<void> removeTheorem(int workspaceId, String token) async {
    Uri url = Uri.parse("${Constants.apiUrl}/remove_workspace_theorem/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Token $token",
      "content-type": "application/json",
    });
    request.fields.addAll({
      'workspace_id': "$workspaceId",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw EditEntryException();
    } else {
      throw Exception("Something has happened");
    }
  }
}
