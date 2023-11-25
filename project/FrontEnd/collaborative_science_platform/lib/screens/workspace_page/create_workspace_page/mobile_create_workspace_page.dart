import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';

class MobileCreateWorkspacePage extends StatefulWidget {
  static const routeName = '/create-workspace';
  const MobileCreateWorkspacePage({super.key});

  @override
  State<MobileCreateWorkspacePage> createState() => _MobileCreateWorkspacePageState();
}

class _MobileCreateWorkspacePageState extends State<MobileCreateWorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
      appBar: SimpleAppBar(title: "Create Workspace"),
      child: Center(
        child: Text(
          "This is the mobile page where you can create workspace",
        ),
      ),
    );
  }
}
