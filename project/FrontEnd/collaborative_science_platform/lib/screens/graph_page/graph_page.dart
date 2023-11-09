import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/center_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/node_list.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  static const routeName = '/graph';

  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  SmallNode node = SmallNode(
      nodeId: 1,
      nodeTitle: "asaf",
      contributors: [Contributor(name: "abdullah", surname: "susuz", email: "asjk@gmail.com")],
      publishDate: DateTime(2023));

  @override
  Widget build(BuildContext context) {
    // others profile page, will be same both on desktop and mobile
    List<SmallNode> references = [
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node
    ];
    List<SmallNode> citations = [
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node,
      node
    ];
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      pageColor: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              height: 1000,
              child: NodeList(
                nodes: references,
              ),
            ),
          ),
          CenterNode(node: node),
          Expanded(
            child: SizedBox(
              height: 1000,
              child: NodeList(
                nodes: citations,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
