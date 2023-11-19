import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_page_node_card.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/node_list.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WebGraphPage extends StatefulWidget {
  final NodeDetailed node;

  const WebGraphPage({
    super.key,
    required this.node,
  });

  @override
  State<WebGraphPage> createState() => _WebGraphPageState();
}

class _WebGraphPageState extends State<WebGraphPage> {
  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      pageColor: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.node.references.isEmpty
              ? const Center(
                  child: SelectableText(
                    "No references",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Flexible(
                  flex: 2,
                  child: NodeList(
                      nodes: widget.node.references,
                      title: "References",
                      width: MediaQuery.of(context).size.width / 3.2),
                ),
          Flexible(
            flex: 6,
            child: GraphPageNodeCard(
                node: widget.node,
                onTap: () => context.go('${NodeDetailsPage.routeName}/${widget.node.nodeId}')),
          ),
          widget.node.citations.isEmpty
              ? const Center(
                  child: SelectableText(
                    "No citations",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Flexible(
                  flex: 2,
                  child: NodeList(
                    nodes: widget.node.citations,
                    title: "Citations",
                    width: MediaQuery.of(context).size.width / 3.2,
                  ),
                ),
        ],
      ),
    );
  }
}
