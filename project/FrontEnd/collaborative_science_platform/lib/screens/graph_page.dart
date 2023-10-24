import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  static const routeName = '/graph';
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(appBar: HomePageAppBar(), child: Text("Graph")); // Profile Page Content
  }
}
