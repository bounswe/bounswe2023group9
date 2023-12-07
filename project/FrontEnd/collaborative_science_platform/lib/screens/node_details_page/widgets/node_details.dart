import 'package:collaborative_science_platform/helpers/node_helper.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_tab_bar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/proof_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/questions_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/references_list_view.dart';
import 'package:collaborative_science_platform/services/share_page.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/annotation_text.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
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
      height: MediaQuery.of(context).size.height - 60,
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
                          textAlign: TextAlign.center, style: TextStyles.title2)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4.0),
                      SelectableText.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                            text: widget.node.publishDateFormatted,
                            style: TextStyles.bodyBlack,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: AppButton(
                              text: "Graph",
                              height: 40,
                              icon: const Icon(
                                CupertinoIcons.square_grid_3x2,
                                size: 16,
                                color: Colors.white,
                              ),
                              type: "secondary",
                              onTap: () {
                                context.push('${GraphPage.routeName}/${widget.node.nodeId}');
                              }),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 110,
                          child: AppButton(
                            text: "Share",
                            icon: const Icon(
                              Icons.share,
                              size: 16,
                              color: Colors.white,
                            ),
                            height: 40,
                            type: "primary",
                            onTap: () => SharePage.shareNodeView(widget.node),
                          ),
                        ),
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
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: TeXView(
                                renderingEngine: const TeXViewRenderingEngine.katex(),
                                child: TeXViewDocument(
                                    NodeHelper.getNodeContentLatex(widget.node, "long"))))),
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
                      contributors: widget.node.contributors, controller: widget.controller),
              ),
            const SizedBox(height: 80.0),
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
