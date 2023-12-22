import 'package:collaborative_science_platform/models/workspaces_page/workspaces_object.dart';

class Workspaces {
  List<WorkspacesObject> workspaces;
  List<WorkspacesObject> pendingWorkspaces;
  List<WorkspacesObject> reviewWorkspaces;
  List<WorkspacesObject> pendingReviewWorkspaces;
  Workspaces({
    required this.workspaces,
    required this.pendingWorkspaces,
    required this.pendingReviewWorkspaces,
    required this.reviewWorkspaces,
  });

  factory Workspaces.fromJson(Map<String, dynamic> jsonString) {
    var workspacesList = jsonString['workspaces'] as List;
    var pendingWorkspacesList = jsonString['pending_workspaces'] as List;
    var reviewWorkspacesList = jsonString['review_workspaces'] as List;
    var pendingReviewWorkspacesList = jsonString['pending_review_workspaces'] as List;

    List<WorkspacesObject> workspaces =
        workspacesList.map((e) => WorkspacesObject.fromJson(e)).toList();

    List<WorkspacesObject> pendingWorkspaces =
        pendingWorkspacesList.map((e) => WorkspacesObject.fromJson(e)).toList();

    List<WorkspacesObject> reviewWorkspaces =
        reviewWorkspacesList.map((e) => WorkspacesObject.fromJson(e)).toList();

    List<WorkspacesObject> pendingReviewWorkspaces =
        pendingReviewWorkspacesList.map((e) => WorkspacesObject.fromJson(e)).toList();
    return Workspaces(
        workspaces: workspaces,
        pendingWorkspaces: pendingWorkspaces,
        reviewWorkspaces: reviewWorkspaces,
        pendingReviewWorkspaces: pendingReviewWorkspaces);
  }
}
