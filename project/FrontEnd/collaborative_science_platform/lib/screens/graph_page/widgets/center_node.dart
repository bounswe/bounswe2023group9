import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:flutter/material.dart';

class CenterNode extends StatelessWidget {
  final SmallNode node;
  final Color? color;

  const CenterNode({
    super.key,
    required this.node,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GraphNodeCard(
      smallNode: node,
      onTap: () {
        Navigator.pushNamed(context, NodeDetailsPage.routeName, arguments: node.nodeId);
      },
    );
  }
}
