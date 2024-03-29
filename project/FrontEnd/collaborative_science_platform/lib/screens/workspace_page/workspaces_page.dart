import 'package:collaborative_science_platform/exceptions/workspace_exceptions.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/wiki_data_provider.dart';
import 'package:collaborative_science_platform/providers/workspace_provider.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/web_workspace_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'mobile_workspace_page/mobile_workspace_page.dart';

class WorkspacesPage extends StatefulWidget {
  static const routeName = '/workspaces';
  final int workspaceId;
  const WorkspacesPage({super.key, this.workspaceId = -1});
  @override
  State<WorkspacesPage> createState() => _WorkspacesPageState();
}

class _WorkspacesPageState extends State<WorkspacesPage> {
  bool _isFirstTime = true;
  bool error = false;
  String errorMessage = "";

  bool isLoading = false;

  Workspace? workspace;
  Workspaces? workspaces;

  void getWorkspaceById(int id) async {
    try {
      print("Workspace Id: $id");
      final workspaceProvider = Provider.of<WorkspaceProvider>(context);
      final auth = Provider.of<Auth>(context);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.getWorkspaceById(id, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on WorkspaceDoesNotExist {
      setState(() {
        error = true;
        errorMessage = WorkspaceDoesNotExist().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getUserWorkspaces() async {
    try {
      final auth = Provider.of<Auth>(context);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.getUserWorkspaces(auth.basicUser!.basicUserId, auth.user!.token);
      setState(() {
        workspaces = (workspaceProvider.workspaces ?? {} as Workspaces);
      });
    } on WorkspaceDoesNotExist {
      setState(() {
        error = true;
        errorMessage = WorkspaceDoesNotExist().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void createNewWorkspace(String title) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.createWorkspace(title, auth.user!.token);
      await workspaceProvider.getUserWorkspaces(auth.basicUser!.basicUserId, auth.user!.token);
      setState(() {
        workspaces = (workspaceProvider.workspaces ?? {} as Workspaces);
      });
    } on CreateWorkspaceException {
      setState(() {
        error = true;
        errorMessage = CreateWorkspaceException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void createNewEntry(String content) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.addEntry(content, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on AddEntryException {
      setState(() {
        error = true;
        errorMessage = AddEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void editEntry(String content, int entryId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.editEntry(content, entryId, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteEntry(int entryId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.deleteEntry(entryId, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addReference(int nodeId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.addReference(widget.workspaceId, nodeId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on AddReferenceException {
      setState(() {
        error = true;
        errorMessage = AddReferenceException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteReference(int nodeId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.deleteReference(widget.workspaceId, nodeId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on DeleteReferenceException {
      setState(() {
        error = true;
        errorMessage = DeleteReferenceException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void editWorkspaceTitle(String title) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.updateWorkspaceTitle(widget.workspaceId, auth.user!.token, title);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getUserWorkspaces(auth.basicUser!.basicUserId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
        workspaces = (workspaceProvider.workspaces ?? {} as Workspaces);
      });
    } on WorkspacePermissionException {
      setState(() {
        error = true;
        errorMessage = WorkspacePermissionException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void finalizeWorkspace() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.finalizeWorkspace(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on FinalizeWorkspaceException {
      setState(() {
        error = true;
        errorMessage = FinalizeWorkspaceException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendWorkspaceToReview() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.sendWorkspaceToReview(
          widget.workspaceId, auth.basicUser!.basicUserId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on FinalizeWorkspaceException {
      setState(() {
        error = true;
        errorMessage = FinalizeWorkspaceException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendCollaborationRequest(int receiverId, String title, String body) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.sendCollaborationRequest(auth.basicUser!.basicUserId, receiverId,
          title, body, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on SendCollaborationRequestException {
      setState(() {
        error = true;
        errorMessage = SendCollaborationRequestException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateCollaborationRequest(int id, RequestStatus status) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.updateCollaborationRequest(id, status, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getUserWorkspaces(auth.basicUser!.basicUserId, auth.user!.token);
      setState(() {
        workspaces = (workspaceProvider.workspaces ?? {} as Workspaces);
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on SendCollaborationRequestException {
      setState(() {
        error = true;
        errorMessage = SendCollaborationRequestException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateReviewRequest(int id, RequestStatus status) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.updateReviewRequest(id, status, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getUserWorkspaces(auth.basicUser!.basicUserId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
        workspaces = (workspaceProvider.workspaces ?? {} as Workspaces);
      });
    } on SendCollaborationRequestException {
      setState(() {
        error = true;
        errorMessage = SendCollaborationRequestException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addSemanticTag(String wikiId, String label) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final wikiDataProvider = Provider.of<WikiDataProvider>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      wikiDataProvider.addSemanticTag(wikiId, label, widget.workspaceId, 'workspace', auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on WorkspacePermissionException {
      setState(() {
        error = true;
        errorMessage = WorkspacePermissionException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void removeSemanticTag(int tagId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final wikiDataProvider = Provider.of<WikiDataProvider>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await wikiDataProvider.removeSemanticTag(widget.workspaceId, tagId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on WorkspacePermissionException {
      setState(() {
        error = true;
        errorMessage = WorkspacePermissionException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addReview(int id, RequestStatus status, String comment) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.addReview(id, status, comment, auth.user!.token);
      await workspaceProvider.getUserWorkspaces(auth.basicUser!.basicUserId, auth.user!.token);
      setState(() {
        workspace = null;
        workspaces = (workspaceProvider.workspaces ?? {} as Workspaces);
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setProof(int entryId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.setProof(entryId, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setDisproof(int entryId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.setDisproof(entryId, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setTheorem(int entryId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.setTheorem(entryId, widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void removeProof() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.removeProof(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void removeDisproof() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.removeDisproof(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void removeTheorem() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.removeTheorem(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void resetWorkspace() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.resetWorkspace(widget.workspaceId, auth.user!.token);
      await workspaceProvider.getWorkspaceById(widget.workspaceId, auth.user!.token);
      setState(() {
        workspace = (workspaceProvider.workspace ?? {} as Workspace);
      });
    } on WorkspaceDoesNotExist {
      setState(() {
        error = true;
        errorMessage = WorkspaceDoesNotExist().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      if (widget.workspaceId > -1) {
        getWorkspaceById(widget.workspaceId);
      }
      getUserWorkspaces();

      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileWorkspacePage(
        workspace: workspace,
        workspaces: workspaces,
        createNewWorkspace: createNewWorkspace,
        createNewEntry: createNewEntry,
        editEntry: editEntry,
        deleteEntry: deleteEntry,
        addReference: addReference,
        deleteReference: deleteReference,
        editTitle: editWorkspaceTitle,
        addSemanticTag: addSemanticTag,
        removeSemanticTag: removeSemanticTag,
        sendCollaborationRequest: sendCollaborationRequest,
        finalizeWorkspace: finalizeWorkspace,
        sendWorkspaceToReview: sendWorkspaceToReview,
        addReview: addReview,
        updateReviewRequest: updateReviewRequest,
        updateCollaborationRequest: updateCollaborationRequest,
        resetWorkspace: resetWorkspace,

        setProof: setProof,
        setDisproof: setDisproof,
        setTheorem: setTheorem,
        removeProof: removeProof,
        removeDisproof: removeDisproof,
        removeTheorem: removeTheorem,

      ),
      desktop: WebWorkspacePage(
        isLoading: isLoading,
        workspace: workspace,
        workspaces: workspaces,
        createNewWorkspace: createNewWorkspace,
        createNewEntry: createNewEntry,
        editEntry: editEntry,
        deleteEntry: deleteEntry,
        addReference: addReference,
        deleteReference: deleteReference,
        editTitle: editWorkspaceTitle,
        addSemanticTag: addSemanticTag,
        removeSemanticTag: removeSemanticTag,
        sendCollaborationRequest: sendCollaborationRequest,
        finalizeWorkspace: finalizeWorkspace,
        sendWorkspaceToReview: sendWorkspaceToReview,
        addReview: addReview,
        updateReviewRequest: updateReviewRequest,
        updateCollaborationRequest: updateCollaborationRequest,

        resetWorkspace: resetWorkspace,

        setProof: setProof,
        setDisproof: setDisproof,
        setTheorem: setTheorem,
        removeProof: removeProof,
        removeDisproof: removeDisproof,
        removeTheorem: removeTheorem,

      ),
    );
  }
}
