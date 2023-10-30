import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class MockNode {
  int nodeId;
  String nodeTitle;
  List<User> contributors;
  String content;
  DateTime publishDate;
  MockNode({
    required this.nodeId,
    required this.nodeTitle,
    required this.contributors,
    required this.content,
    required this.publishDate,
  });
}

class NodeDetailsPage extends StatefulWidget {
  static const routeName = '/node';
  const NodeDetailsPage({super.key});

  @override
  State<NodeDetailsPage> createState() => _NodeDetailsPageState();
}

class _NodeDetailsPageState extends State<NodeDetailsPage> {
  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  MockNode node = MockNode(
      nodeId: 12,
      nodeTitle: "Very Important Extra Complicated Theory",
      contributors: [
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "omer",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "berberoglu"),
        User(
            firstName: "zulal",
            email: "omerberberoglu@gmail.com",
            id: 0,
            lastName: "molla")
      ],
      content:
          "Summary:\n The Very Important Extra Complicated Theory (VIECT) proposes a groundbreaking framework for understanding the intricate interplay between subatomic particles and their influence on macroscopic phenomena. At its core, VIECT introduces a novel concept of \"Quantum Field Harmonics,\" suggesting that particles exhibit wave-like behavior in multiple dimensions, leading to previously unexplored quantum states.\nKey Postulates:\nQuantum Field Harmonics: VIECT posits that subatomic particles possess a multi-dimensional wave function, giving rise to an extended spectrum of energy states.\nMacroscopic Quantum Resonance (MQR): The theory predicts that under specific conditions, quantum states can synchronize across macroscopic scales, potentially enabling new technological advancements in energy transfer and information processing.\nUniversal Entanglement Equilibrium (UEE): VIECT introduces the concept of UEE, suggesting a fundamental interconnectedness of all particles, regardless of spatial separation.\nDimensional Phase Transcendence (DPT): VIECT proposes the existence of higher-dimensional phases beyond the traditionally recognized three spatial dimensions, providing a potential explanation for dark matter and energy phenomena.\nImplications:\nThe Very Important Extra Complicated Theory has far-reaching implications for various scientific disciplines, including quantum physics, astrophysics, and quantum computing. If validated through experimental evidence, VIECT could revolutionize our understanding of the fundamental nature of the universe and pave the way for unprecedented technological advancements.",
      publishDate: DateTime(2022, 9, 4));
  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
        appBar: const HomePageAppBar(),
        pageColor: Colors.grey.shade200,
        child: Responsive.isDesktop(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Contributors(
                    contributors: node.contributors,
                    controller: controller1,
                  ),
                  NodeDetails(
                    node: node,
                    controller: controller2,
                  ),
                ],
              )
            : NodeDetails(
                node: node,
                controller: controller2,
              ));
  }
}
