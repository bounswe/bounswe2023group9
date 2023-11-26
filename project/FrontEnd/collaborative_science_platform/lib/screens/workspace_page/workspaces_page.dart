import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/web_workspace_page.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';
import 'mobile_workspace_page/mobile_workspace_page.dart';

class WorkspacesPage extends StatelessWidget {
  static const routeName = '/workspaces';
  const WorkspacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileWorkspacePage(),
      desktop: WebWorkspacePage(),
    );
  }
}
