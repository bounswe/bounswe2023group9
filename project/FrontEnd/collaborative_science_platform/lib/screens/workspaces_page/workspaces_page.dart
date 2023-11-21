import 'package:collaborative_science_platform/screens/workspaces_page/mobile_workspaces_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/web_workspace_page.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';

class WorkspacesPage extends StatelessWidget {
  static const routeName = '/workspaces';
  const WorkspacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileWorkspacesPage(),
      desktop: WebWorkspacePage(),
    );
  }
}
