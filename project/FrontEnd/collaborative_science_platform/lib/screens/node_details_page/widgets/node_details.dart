import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/models/theorem.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_tab_bar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/proof_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/questions_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/references_list_view.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

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
      width: Responsive.getGenericPageWidth(context),
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
                      padding: Responsive.isDesktop(context) ? const EdgeInsets.all(70.0) : const EdgeInsets.all(10.0),
                      child: Text(widget.node.nodeTitle,
                          textAlign: TextAlign.center,
                          style: Responsive.isDesktop(context) ? TextStyles.title1 : TextStyles.title2)),
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
                          child: Text(widget.node.theorem!.theoremContent,
                              style: TextStyles.bodyBlack),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
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
                child: QuestionsView(questions: [
                  Question(
                      question: "What is a Finite Automaton?",
                      answer:
                          "A Finite Automaton, also known as a Finite State Machine (FSM), is a theoretical model used in computer science and mathematics to describe computation processes. It consists of a finite set of states, an input alphabet, transition rules, an initial state, and a set of accepting (or final) states."),
                  Question(
                      question: "Can a Finite Automaton recognize context-free languages?",
                      answer:
                          "No, Finite Automata can only recognize regular languages, which are a subset of context-free languages. Context-free languages require more powerful models like Pushdown Automata or Turing Machines for recognition.")
                ]),
              ),
            if (currentIndex == 5)
              //Q/A
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
