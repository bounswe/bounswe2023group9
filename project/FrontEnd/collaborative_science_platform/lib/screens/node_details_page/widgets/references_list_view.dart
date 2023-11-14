import 'package:collaborative_science_platform/models/node_details_page/node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ReferencesView extends StatelessWidget {
  final List<Node> nodes;
  final bool ref;
  const ReferencesView({super.key, required this.nodes, this.ref = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: nodes.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: CardContainer(
                onTap: () {
                  Navigator.pushNamed(context, NodeDetailsPage.routeName,
                      arguments: nodes[index].id);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nodes[index].nodeTitle,
                      style: TextStyles.title4,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      nodes[index]
                          .contributors
                          .map((e) => "by ${e.firstName} ${e.lastName}")
                          .join(", "),
                      style: TextStyles.bodyGrey,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      nodes[index].publishDate.toString(),
                      style: TextStyles.bodyGrey,
                      textAlign: TextAlign.start,
                    ),
                    
                  ],
                ),
              ),
            );
          }),
    );
  }
}
