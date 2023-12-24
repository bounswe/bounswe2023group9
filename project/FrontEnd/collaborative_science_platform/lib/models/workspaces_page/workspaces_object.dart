class WorkspacesObject {
  int workspaceId;
  String workspaceTitle;
  bool pending;
  int requestId;
  WorkspacesObject({
    required this.workspaceId,
    required this.workspaceTitle,
    required this.pending,
    this.requestId = -1,
  });

  factory WorkspacesObject.fromJson(Map<String, dynamic> jsonString) {
    return WorkspacesObject(
        workspaceId: jsonString['workspace_id'],
        workspaceTitle: jsonString['workspace_title'],
        pending: jsonString['pending']);
  }
  factory WorkspacesObject.fromJsonforRequests(Map<String, dynamic> jsonString) {
    return WorkspacesObject(
      workspaceId: jsonString['workspace_id'],
      workspaceTitle: jsonString['workspace_title'],
      pending: jsonString['pending'],
      requestId: jsonString['request_id'],
    );
        
  }
}
