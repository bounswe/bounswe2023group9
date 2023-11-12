import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/center_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/node_list.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class WebGraphPage extends StatefulWidget {
  final SmallNode smallNode;

  const WebGraphPage({
    super.key,
    required this.smallNode,
  });

  @override
  State<WebGraphPage> createState() => _WebGraphPageState();
}

class _WebGraphPageState extends State<WebGraphPage> {
  SmallNode node = SmallNode(
      nodeId: 1,
      nodeTitle: "Altkümelerin Üretici Fonksiyonları",
      contributors: [Contributor(name: "Abdullah", surname: "Susuz", email: "demo@boun.edu.tr")],
      publishDate: DateTime(2023));

  @override
  Widget build(BuildContext context) {
    // others profile page, will be the same both on desktop and mobile
    List<SmallNode> references = List.generate(15, (index) => node);
    List<SmallNode> citations = List.generate(15, (index) => node);

    const listRatio = 0.2;

    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      pageColor: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: NodeList(
              nodes: references,
              title: "References",
              width: Responsive.getGenericPageWidth(context) * listRatio,
            ),
          ),
          Flexible(
            flex: 6,
            child: CenterNode(
              node: node,
              width: Responsive.getGenericPageWidth(context) * (1 - listRatio * 2),
            ),
          ),
          Flexible(
            flex: 2,
            child: NodeList(
              nodes: citations,
              title: "Citations",
              width: Responsive.getGenericPageWidth(context) * listRatio,
            ),
          ),
        ],
      ),
    );
  }
}
