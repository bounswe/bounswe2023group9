import 'package:collaborative_science_platform/exceptions/workspace_exceptions.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
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
        print(errorMessage);
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
        print(errorMessage);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateCollaborationRequest(int id, String status) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.updateCollaborationRequest(id, status, auth.user!.token);
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

  void addSemanticTags(List<int> semanticTags) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
      });
      await workspaceProvider.addSemanticTags(widget.workspaceId, auth.user!.token, semanticTags);
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
        addSemanticTags: addSemanticTags,
        updateRequest: updateCollaborationRequest,
        sendCollaborationRequest: sendCollaborationRequest,
        finalizeWorkspace: finalizeWorkspace,

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
        addSemanticTags: addSemanticTags,
        updateRequest: updateCollaborationRequest,
        sendCollaborationRequest: sendCollaborationRequest,
        finalizeWorkspace: finalizeWorkspace,
      ),
    );
  }
}
