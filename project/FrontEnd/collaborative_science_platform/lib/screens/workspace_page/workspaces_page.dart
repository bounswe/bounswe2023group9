import 'package:collaborative_science_platform/exceptions/workspace_exceptions.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/workspace_provider.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/web_workspace_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/responsive/responsive.dart';
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
      await workspaceProvider.editEntry(content, entryId, auth.user!.token);
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
      ),
      desktop: WebWorkspacePage(
        isLoading: isLoading,
        workspace: workspace,
        workspaces: workspaces,
        createNewWorkspace: createNewWorkspace,
        createNewEntry: createNewEntry,
        editEntry: editEntry,
        deleteEntry: deleteEntry,
      ),
    );
  }
}
