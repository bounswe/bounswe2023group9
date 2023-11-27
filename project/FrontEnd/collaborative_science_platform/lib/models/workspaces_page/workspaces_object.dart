class WorkspacesObject {
  int workspaceId;
  String workspaceTitle;
  bool pending;
  WorkspacesObject({
    required this.workspaceId,
    required this.workspaceTitle,
    required this.pending,
  });

  factory WorkspacesObject.fromJson(Map<String, dynamic> jsonString) {
    return WorkspacesObject(
        workspaceId: jsonString['workspace_id'],
        workspaceTitle: jsonString['workspace_title'],
        pending: jsonString['pending']);
  }
}
