import 'package:collaborative_science_platform/exceptions/node_details_exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/graph_page/mobile_graph_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/web_graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatefulWidget {
  static const routeName = '/graph';
  final int nodeId;
  const GraphPage({super.key, this.nodeId = -1});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  NodeDetailed node = NodeDetailed();
  bool _isFirstTime = true;
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getNode();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  void getNode() async {
    try {
      final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      if (nodeProvider.nodeDetailed != null) {
        if (nodeProvider.nodeDetailed!.nodeId == widget.nodeId) {
          setState(() {
            node = nodeProvider.nodeDetailed!;
          });
          return;
        }
      }
      await nodeProvider.getNode(widget.nodeId);
      setState(() {
        node = nodeProvider.nodeDetailed!;
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
    if (isLoading || error) {
      return PageWithAppBar(
        appBar: const HomePageAppBar(),
        child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )),
      );
    } else {
      return Responsive(
        mobile: MobileGraphPage(node: node),
        desktop: WebGraphPage(node: node),
      );
    }
  }
}
