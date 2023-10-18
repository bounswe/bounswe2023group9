
import 'package:flutter/material.dart';

import '../widgets/app_bottom_navigation_bar.dart';

class WorkspacesPage extends StatefulWidget {
  static const routeName = '/workspaces';
  const WorkspacesPage({super.key});

  @override
  State<WorkspacesPage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Workspaces"),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
      body: Container(), // Workspaces Page Content
    );
  }
}
