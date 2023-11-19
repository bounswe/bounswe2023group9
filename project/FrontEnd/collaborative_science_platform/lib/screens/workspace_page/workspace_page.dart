import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';

class WorkspacePage extends StatelessWidget {
  static const routeName = '/workspace';
  final int workspaceId;
  const WorkspacePage({
    super.key,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileWorkspacePage(workspaceId: workspaceId),
      desktop: WebWorkspacePage(workspaceId: workspaceId),
    );
  }
}
