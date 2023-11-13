import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
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
      final nodeDetailsProvider = Provider.of<NodeProvider>(context);
      setState(() {
        error = false;
        isLoading = true;
      });
      await nodeDetailsProvider.getNode(widget.nodeID);

      setState(() {
        node = (nodeDetailsProvider.nodeDetailed ?? {} as NodeDetailed);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
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
              padding: const EdgeInsets.only(top: 32),
              decoration: const BoxDecoration(color: Colors.white),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : error
              ? Text(errorMessage, style: const TextStyle(color: Colors.red))
              : Responsive.isDesktop(context)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Contributors(
                          contributors: node.contributors, //widget.inputNode.contributors,
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
                    ),
    );
  }
}
