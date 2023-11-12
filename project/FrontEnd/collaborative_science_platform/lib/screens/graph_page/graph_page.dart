import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/screens/graph_page/mobile_graph_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/web_graph_page.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import '../../models/small_node.dart';

class GraphPage extends StatefulWidget {
  static const routeName = '/graph';
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late SmallNode smallNode;

  @override
  void initState() {
    super.initState();
    getNode();
  }

  void getNode() {
    smallNode = SmallNode( // Example Node
      nodeId: 1,
      nodeTitle: "Cartesian Coordinate System",
      contributors: [Contributor(name: "Rene", surname: "Descartes", email: "rene.descartes1596@renaissance.com")],
      publishDate: DateTime(1630, 7, 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context) ?
      MobileGraphPage(smallNode: smallNode) : WebGraphPage(smallNode: smallNode);
  }
}
