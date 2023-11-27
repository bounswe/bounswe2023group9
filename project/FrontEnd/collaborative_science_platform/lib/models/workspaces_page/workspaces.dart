import 'package:collaborative_science_platform/models/workspaces_page/workspaces_object.dart';

class Workspaces {
  List<WorkspacesObject> workspaces;
  List<WorkspacesObject> pendingWorkspaces;
  Workspaces({
    required this.workspaces,
    required this.pendingWorkspaces,
  });

  factory Workspaces.fromJson(Map<String, dynamic> jsonString) {
    var workspacesList = jsonString['workspaces'] as List;
    var pendingWorkspacesList = jsonString['pending_workspaces'] as List;

    List<WorkspacesObject> workspaces =
        workspacesList.map((e) => WorkspacesObject.fromJson(e)).toList();

    List<WorkspacesObject> pendingWorkspaces =
        pendingWorkspacesList.map((e) => WorkspacesObject.fromJson(e)).toList();
    return Workspaces(workspaces: workspaces, pendingWorkspaces: pendingWorkspaces);
  }
}
