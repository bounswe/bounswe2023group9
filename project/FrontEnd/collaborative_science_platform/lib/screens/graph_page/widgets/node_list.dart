import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:flutter/material.dart';

class NodeList extends StatelessWidget {
  final List<SmallNode> nodes;
  final Color? color;

  const NodeList({
    super.key,
    required this.nodes,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GraphNodeCard(
              smallNode: nodes[index],
              onTap: () => Navigator.pushNamed(
                context,
                NodeDetailsPage.routeName,
                arguments: nodes[index].nodeId,
              ),
            ),
          );
        },
      ),
    );
  }
}
