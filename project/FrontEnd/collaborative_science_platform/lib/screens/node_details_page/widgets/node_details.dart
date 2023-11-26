import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_tab_bar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/proof_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/questions_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/references_list_view.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/annotation_text.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class NodeDetails extends StatefulWidget {
  final NodeDetailed node;
  final ScrollController controller;
  const NodeDetails({
    super.key,
    required this.node,
    required this.controller,
  });

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
      width: Responsive.isDesktop(context)
          ? Responsive.desktopPageWidth * 0.8
          : Responsive.getGenericPageWidth(context),
      child: SingleChildScrollView(
        primary: false,
        scrollDirection: Axis.vertical,
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
                      child: AnnotationText(utf8.decode(widget.node.nodeTitle.codeUnits),
                          textAlign: TextAlign.center, style: TextStyles.title2)),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(
                      children: [
                        SelectableText.rich(
                          TextSpan(children: <TextSpan>[
                            const TextSpan(
                              text: "published on ",
                              style: TextStyles.bodyGrey,
                            ),
                            TextSpan(
                              text: widget.node.publishDateFormatted,
                              style: TextStyles.bodyBlack,
                            )
                          ]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: Responsive.getGenericPageWidth(context) * 0.35,
                          child: AppButton(
                              text: "See the Graph",
                              height: 40,
                              type: "secondary",
                              onTap: () {
                                context.push('${GraphPage.routeName}/${widget.node.nodeId}');
                              }),
                        )
                      ],
                    ),
                  ]),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    width: Responsive.desktopPageWidth,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: CardContainer(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: TeXView(
                                renderingEngine: TeXViewRenderingEngine.katex(),
                                child: TeXViewDocument(
                                    utf8.decode(widget.node.theorem!.theoremContent.codeUnits)))),
                        SelectableText.rich(
                          textAlign: TextAlign.start,
                          TextSpan(children: <TextSpan>[
                            const TextSpan(
                              text: "published on ",
                              style: TextStyles.bodyGrey,
                            ),
                            TextSpan(
                              text: widget.node.publishDateFormatted,
                              style: TextStyles.bodyBlack,
                            )
                          ]),
                        ),
                      ],
                    )),
                  )),
            if (currentIndex == 1)
              //proofs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ProofListView(proof: widget.node.proof),
              ),
            if (currentIndex == 2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ReferencesView(nodes: widget.node.references, ref: true),
              ),
            if (currentIndex == 3)
              //citations
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ReferencesView(nodes: widget.node.citations),
              ),
            if (currentIndex == 4)
              //Q/A
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: QuestionsView(questions: widget.node.questions),
              ),
            if (currentIndex == 5)
              //contributors
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Contributors(
                      contributors: widget.node.contributors, controller: widget.controller)),
          ],
        ),
      ),
    );
  }
}

bool containsMathExpression(String text) {
  // Check if the text contains the '$' symbol indicating a mathematical expression
  return text.contains(r'$');
}
