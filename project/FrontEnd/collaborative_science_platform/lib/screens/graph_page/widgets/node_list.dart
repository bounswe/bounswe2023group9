import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_node_popup.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:flutter/material.dart';

class NodeList extends StatefulWidget {
  final String title;
  final List<Node> nodes;
  final Color? color;
  final double width;

  const NodeList({
    Key? key,
    required this.nodes,
    required this.title,
    required this.width,
    this.color,
  }) : super(key: key);

  @override
  State<NodeList> createState() => _NodeListState();
}

class _NodeListState extends State<NodeList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Card(
          color: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ExpansionTile(
            shape: const Border(),
            tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            title: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            children: [
              // Display the list of nodes
              Column(
                children: widget.nodes.map((node) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: HomePageNodeCard(
                        smallNode: node, onTap: () => _showNodeDetailsPopup(context, node)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showNodeDetailsPopup(BuildContext context, Node node) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NodeDetailsPopup(nodeId: node.id);
      },
    );
  }
}
