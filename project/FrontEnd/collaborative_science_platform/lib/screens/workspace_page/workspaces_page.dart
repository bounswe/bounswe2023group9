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
      ),
      desktop: WebWorkspacePage(
        workspace: workspace,
        workspaces: workspaces,
      ),
    );
  }
}
