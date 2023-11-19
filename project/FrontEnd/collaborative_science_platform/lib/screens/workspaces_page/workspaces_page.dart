import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/web_workspace_page.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class WorkspacesPage extends StatelessWidget {
  static const routeName = '/workspaces';
  final int workspaceId;
  const WorkspacesPage({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? WebWorkspacePage(workspaceId: workspaceId)
        : const PageWithAppBar(
        appBar: HomePageAppBar(), child: Text("Workspaces")); // Profile Page Content
  }
}
