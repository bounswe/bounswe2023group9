import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/graph_page/mobile_graph_page.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  static const routeName = '/graph';
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late NodeDetailed node;
  bool _isFirstTime = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getNode();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getNode() async {}

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileGraphPage(node: node, isLoading: isLoading),
      desktop: MobileGraphPage(node: node, isLoading: isLoading),
    );
  }
}
