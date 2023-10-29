import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_tab_bar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/references.dart';
import 'package:collaborative_science_platform/utils/textStyles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class DesktopNodeDetails extends StatefulWidget {
  final MockNode node;
  final ScrollController controller;
  const DesktopNodeDetails(
      {super.key, required this.node, required this.controller});

  @override
  State<DesktopNodeDetails> createState() => _DesktopNodeDetailsState();
}

class _DesktopNodeDetailsState extends State<DesktopNodeDetails> {
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
                      padding: const EdgeInsets.all(70.0),
                      child: Text(widget.node.nodeTitle,
                          textAlign: TextAlign.center,
                          style: TextStyles.title1)),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: References(references: const []),
              ),
            if (currentIndex == 2)
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
          ],
        ),
      ),
    );
  }
}
