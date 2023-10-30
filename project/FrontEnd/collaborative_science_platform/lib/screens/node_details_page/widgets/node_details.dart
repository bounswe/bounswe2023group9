import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_tab_bar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/references.dart';
import 'package:collaborative_science_platform/utils/textStyles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NodeDetails extends StatefulWidget {
  final MockNode node;
  final ScrollController controller;
  const NodeDetails(
      {super.key, required this.node, required this.controller});

  @override
  State<NodeDetails> createState() => _NodeDetailsState();
}

class _NodeDetailsState extends State<NodeDetails> {
  int currentIndex = 0;

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      width: Responsive.getGenericPageWidth(context),
      child: SingleChildScrollView(
        primary: false,
        scrollDirection: Axis.vertical,
        //controller: widget.controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: CardContainer(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: Responsive.isDesktop(context)
                          ? const EdgeInsets.all(70.0)
                          : const EdgeInsets.all(10.0),
                      child: Text(widget.node.nodeTitle,
                          textAlign: TextAlign.center,
                          style: Responsive.isDesktop(context)
                              ? TextStyles.title1
                              : TextStyles.title2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                            text: "published on ",
                            style: TextStyles.bodyGrey,
                          ),
                          TextSpan(
                            text: widget.node.publishDate.toString(),
                            style: TextStyles.bodyBlack,
                          )
                        ]),
                      ),
                    ],
                  ),
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: NodeDetailsTabBar(
                callback: updateIndex,
              ),
            ),
            if (currentIndex == 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CardContainer(
                  child: Text(
                    widget.node.content,
                    style: TextStyles.bodyBlack,
                  ),
                ),
              ),
            if (currentIndex == 1)
              //proofs
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CardContainer(
                  child: Text(
                    widget.node.content,
                    style: TextStyles.bodyBlack,
                  ),
                ),
              ),
            if (currentIndex == 2)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: References(references: [
                  SmallNode.getLoremIpsum(1),
                  SmallNode.getLoremIpsum(1),
                  SmallNode.getLoremIpsum(1)
                ]),
              ),
            if (currentIndex == 3)
              //citations
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: References(references: [
                  SmallNode.getLoremIpsum(1),
                  SmallNode.getLoremIpsum(1),
                  SmallNode.getLoremIpsum(1)
                ]),
              ),
            if (currentIndex == 4)
              //Q/A
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CardContainer(
                  child: Text(
                    "",
                    style: TextStyles.bodyBlack,
                  ),
                ),
              ),
            if (currentIndex == 5)
              //Q/A
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Contributors(
                      contributors: widget.node.contributors,
                      controller: widget.controller)),
          ],
        ),
      ),
    );
  }
}
