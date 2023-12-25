import 'package:collaborative_science_platform/helpers/node_helper.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_menu.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_tab_bar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/proof_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/questions_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/references_list_view.dart';
import 'package:collaborative_science_platform/services/share_page.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
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
import 'package:provider/provider.dart';

class NodeDetails extends StatefulWidget {
  final NodeDetailed node;
  final ScrollController controller;
  final Function createNewWorkspacefromNode;
  final String userType;
  final Function() onTap;

  const NodeDetails({
    super.key,
    required this.node,
    required this.controller,
    required this.createNewWorkspacefromNode,
    required this.userType,
    required this.onTap,
  });

  @override
  State<NodeDetails> createState() => _NodeDetailsState();
}

class _NodeDetailsState extends State<NodeDetails> {
  int currentIndex = 0;
  bool canAnswerQuestions = false;
  bool canAskQuestions = false;

  @override
  void initState() {
    super.initState();
    canAnswer();
  }

  @override
  void didUpdateWidget(covariant NodeDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node != widget.node) {
      canAnswer();
    }
  }

  bool showAnnotations = false;

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void canAnswer() async {
    Auth authProvider = Provider.of<Auth>(context, listen: false);
    setState(() {
      canAnswerQuestions = authProvider.isSignedIn &&
          authProvider.basicUser != null &&
          widget.node.contributors
              .any((contributor) => contributor.id == authProvider.basicUser!.basicUserId);
      canAskQuestions = authProvider.isSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      width: Responsive.isDesktop(context)
          ? Responsive.desktopNodePageWidth * 0.8
          : Responsive.getGenericPageWidth(context),
      height: MediaQuery.of(context).size.height - 60,
      child: SingleChildScrollView(
        primary: false,
        scrollDirection: Axis.vertical,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: CardContainer(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NodeDetailsMenu(
                            createNewWorkspacefromNode: widget.createNewWorkspacefromNode)
                      ],
                    ),
                    Padding(
                        padding: Responsive.isDesktop(context)
                            ? const EdgeInsets.all(70.0)
                            : const EdgeInsets.all(10.0),
                        child: SelectableText(utf8.decode(widget.node.nodeTitle.codeUnits),
                            textAlign: TextAlign.center, style: TextStyles.title2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectableText.rich(
                          TextSpan(
                            text: widget.node.publishDateFormatted,
                            style: TextStyles.bodyBlack,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget.userType == "admin" ? true : false,
                              child: widget.node.isHidden
                                  ? SizedBox(
                                      width: 110,
                                      child: AppButton(
                                        text: "Show",
                                        height: 40,
                                        icon: const Icon(
                                          CupertinoIcons.eye,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        type: "grey",
                                        onTap: widget.onTap,
                                      ),
                                    )
                                  : SizedBox(
                                      width: 110,
                                      child: AppButton(
                                        text: "Hide",
                                        height: 40,
                                        icon: const Icon(
                                          CupertinoIcons.eye_slash,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        type: "danger",
                                        onTap: widget.onTap,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 135,
                              child: AppButton(
                                  text: "Relations",
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                width: 180,
                                child: AppButton(
                                    text: showAnnotations ? "Show Text" : "Show Annotations",
                                    height: 40,
                                    onTap: () {
                                      setState(() {
                                        showAnnotations = !showAnnotations;
                                      });
                                    })),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: showAnnotations
                                ? AnnotationText(
                                    NodeHelper.getNodeContentLatex(widget.node, "long"),
                                    "${Constants.appUrl}/node/${widget.node.nodeId}#theorem",
                                    widget.node.contributors
                                        .map((user) => "${Constants.appUrl}/profile/${user.email}")
                                        .toList(),
                                  )
                                : TeXView(
                                    renderingEngine: const TeXViewRenderingEngine.katex(),
                                    child: TeXViewDocument(
                                        NodeHelper.getNodeContentLatex(widget.node, "long")))),
                        SelectableText.rich(
                          textAlign: TextAlign.start,
                          TextSpan(
                            text: widget.node.publishDateFormatted,
                            style: TextStyles.bodyBlack,
                          ),
                        ),
                      ],
                    )),
                  )),
            if (currentIndex == 1)
              //proofs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ProofListView(
                    proof: widget.node.proof,
                    contributors: widget.node.contributors,
                    nodeID: widget.node.nodeId),
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
                child: QuestionsView(
                  questions: widget.node.questions,
                  nodeId: widget.node.nodeId,
                  canAnswer: canAnswerQuestions,
                  canAsk: canAskQuestions,
                  isAdmin: (widget.userType == "admin"),
                ),
              ),
            if (currentIndex == 5)
              //contributors
              Contributors(
                contributors: widget.node.contributors,
                controller: widget.controller,
                semanticTags: const [],
              ),
            if (currentIndex == 6)
              //contributors
              SemantigTagsListView(
                controller: widget.controller,
                semanticTags: widget.node.semanticTags,
              ),
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
