import 'package:collaborative_science_platform/exceptions/node_details_exceptions.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/you_may_like.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      });
    } on NodeDoesNotExist {
      setState(() {
        error = true;
        errorMessage = NodeDoesNotExist().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
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
              ? SelectableText(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
              : Responsive.isDesktop(context)
                  ? WebNodeDetails(node: node)
                  : NodeDetails(
                      node: node,
                      controller: controller2,
                    ),
    );
  }
}

class WebNodeDetails extends StatefulWidget {
  final NodeDetailed node;

  const WebNodeDetails({super.key, required this.node});

  @override
  State<WebNodeDetails> createState() => _WebNodeDetailsState();
}

class _WebNodeDetailsState extends State<WebNodeDetails> {
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  bool _isFirstTime = true;
  bool error = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getNodeSuggestions();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getNodeSuggestions() async {
    try {
      final nodeDetailsProvider = Provider.of<NodeProvider>(context);
      setState(() {
        error = false;
        isLoading = true;
      });
      await nodeDetailsProvider.getNodeSuggestions();
    } on NodeDoesNotExist {
      setState(() {
        error = true;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    BrowserContextMenu.enableContextMenu();
    super.dispose();
  }

  @override
  void initState() {
    BrowserContextMenu.disableContextMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Contributors(
            contributors: widget.node.contributors, //widget.inputNode.contributors,
            controller: controller1,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: NodeDetails(
              node: widget.node,
              controller: controller2,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: YouMayLike(
              isLoading: isLoading,
              error: error,
            ),
          ),
        ],
      ),
    );
  }
}

