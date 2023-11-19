import 'package:collaborative_science_platform/screens/create_workspace_page/web_create_workspace_page.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';
import 'mobile_create_workspace_page.dart';

class CreateWorkspacePage extends StatelessWidget {
  static const routeName = '/create_workspace';
  const CreateWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileCreateWorkspacePage(),
      desktop: WebCreateWorkspacePage(),
    );
  }
}
