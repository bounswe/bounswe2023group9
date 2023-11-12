import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CenterNode extends StatelessWidget {
  final SmallNode node;
  final double width;
  final Color? color;

  const CenterNode({
    super.key,
    required this.node,
    this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GraphNodeCard(
      smallNode: node,
      width: width,
      onTap: () {
        context.go('${NodeDetailsPage.routeName}/${node.nodeId}');
      },
    );
  }
}
