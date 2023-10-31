import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/models/theorem.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/node_details_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NodeDetailsPage extends StatefulWidget {
  static const routeName = '/node';
  //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
  final int nodeID;
  const NodeDetailsPage({super.key, required this.nodeID});

  @override
  State<NodeDetailsPage> createState() => _NodeDetailsPageState();
}

class _NodeDetailsPageState extends State<NodeDetailsPage> {
  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();
  bool _isFirstTime = true;
  NodeDetailed node = NodeDetailed();
  List<Proof> proof = [];
  Theorem theorem = Theorem();
  List<NodeDetailed> references = [];
  List<NodeDetailed> citations = [];
  List<User> contributors = [];

  bool error = false;
  String errorMessage = "";

  bool isLoading = false;
  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getNodeDetails();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getNodeDetails() async {
    try {
      final nodeDetailsProvider = Provider.of<NodeDetailsProvider>(context);
      setState(() {
        isLoading = true;
      });
      await nodeDetailsProvider.getNode(widget.nodeID);

      setState(() {
        node = (nodeDetailsProvider.nodeDetailed ?? {} as NodeDetailed);
        proof = nodeDetailsProvider.proof;
        theorem = nodeDetailsProvider.theorem;
        references = nodeDetailsProvider.references;
        citations = nodeDetailsProvider.citations;
        contributors = nodeDetailsProvider.contributors;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      pageColor: Colors.grey.shade200,
      child: isLoading
          ? Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Contributors(
                      contributors:
                          contributors, //widget.inputNode.contributors,
                      controller: controller1,
                    ),
                    NodeDetails(
                      proofs: proof,
                      contributors:
                          contributors, //widget.inputNode.contributors,
                      theorem: theorem,
                      references: references,
                      citations: citations,
                      node: node,
                      controller: controller2,
                    ),
                  ],
                )
              : NodeDetails(
                  proofs: proof,
                  theorem: theorem,
                  references: references,
                  citations: citations,
                  contributors: contributors, // widget.inputNode.contributors,
                  node: node,
                  controller: controller2,
                ),
    );
  }
}
