import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NodeList extends StatelessWidget {
  final String title;
  final List<Node> nodes;
  final Color? color;
  final double width;

  const NodeList({
    super.key,
    required this.nodes,
    required this.title,
    required this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          children: [
            // Display the list of nodes
            Column(
              children: nodes.map((node) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: GraphNodeCard(
                    node: node,
                    onTap: () => context.push('${GraphPage.routeName}/${node.id}'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
