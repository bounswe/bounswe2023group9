import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:flutter/material.dart';

class NodeCards extends StatelessWidget {
  final List<SmallNode> nodeList;
  final bool firstSearch;

  const NodeCards({
    super.key,
    required this.nodeList,
    required this.firstSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: firstSearch && nodeList.isEmpty
          ? const Center(
              child: Text("No results found."),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: nodeList.length,
              itemBuilder: (context, index) {
                return HomePageNodeCard(
                  smallNode: nodeList[index],
                  onTap: () {
                    Navigator.pushNamed(context, NodeDetailsPage.routeName,
                        arguments: nodeList[index].nodeId);
                  },
                );
              },
            ),
    );
  }
}
