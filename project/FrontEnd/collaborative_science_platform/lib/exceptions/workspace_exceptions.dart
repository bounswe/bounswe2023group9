class WorkspaceDoesNotExist implements Exception {
  String message;
  WorkspaceDoesNotExist({this.message = "Workspace Does Not Exist with the Given ID"});
}

class SendCollaborationRequestException implements Exception {
  String message;
  SendCollaborationRequestException({this.message = "Bad Request"});
}

class CreateWorkspaceException implements Exception {
  String message;
  CreateWorkspaceException(
      {this.message = "Both workspace_id and workspace_title cannot be empty."});
}

class WorkspacePermissionException implements Exception {
  String message;
  WorkspacePermissionException(
      {this.message = "You do not have permission to perform this action."});
}

class AddReferenceException implements Exception {
  String message;
  AddReferenceException({this.message = "Bad Request"});
}

class AddEntryException implements Exception {
  String message;
  AddEntryException({this.message = "Bad Request"});
}

class FinalizeWorkspaceException implements Exception {
  String message;
  FinalizeWorkspaceException({this.message = "Bad Request"});
}

class DeleteReferenceException implements Exception {
  String message;
  DeleteReferenceException({this.message = "Bad Request"});
}

class DeleteWorkspaceException implements Exception {
  String message;
  DeleteWorkspaceException({this.message = "Bad Request"});
}

class EditEntryException implements Exception {
  String message;
  EditEntryException({this.message = "Bad Request"});
}

class DeleteEntryException implements Exception {
  String message;
  DeleteEntryException({this.message = "Bad Request"});
}
