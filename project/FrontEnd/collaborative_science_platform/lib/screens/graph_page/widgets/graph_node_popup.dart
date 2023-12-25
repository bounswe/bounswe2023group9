// node_details_popup.dart

import 'dart:ui';

import 'package:collaborative_science_platform/exceptions/node_details_exceptions.dart';
import 'package:collaborative_science_platform/helpers/node_helper.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class NodeDetailsPopup extends StatefulWidget {
  final int nodeId;

  const NodeDetailsPopup({Key? key, required this.nodeId}) : super(key: key);

  @override
  State<NodeDetailsPopup> createState() => _NodeDetailsPopupState();
}

class _NodeDetailsPopupState extends State<NodeDetailsPopup> {
  NodeDetailed node = NodeDetailed();
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";
  bool _isFirstTime = true;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getNode();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
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
            isLoading = false;
          });
          return;
        }
      }
      await nodeProvider.getNode(widget.nodeId);
      setState(() {
        node = nodeProvider.nodeDetailed!;
        isLoading = false;
      });
    } on NodeDoesNotExist {
      setState(() {
        isLoading = false;
        error = true;
        errorMessage = "Node does not exist!";
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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title: SelectableText(
            utf8.decode(node.nodeTitle.codeUnits),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.5, color: Colors.grey),
                bottom: BorderSide(width: 1.5, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TeXView(
                      renderingEngine: const TeXViewRenderingEngine.katex(),
                      child: TeXViewDocument(
                        NodeHelper.getNodeContentLatex(node, "short"),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      node.contributors
                          .map((user) => "${user.firstName} ${user.lastName} (${user.email})")
                          .join(", "),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          getDurationFromNow(node.publishDate!),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushReplacement('${NodeDetailsPage.routeName}/${node.nodeId}');
              },
              child: const Text('Go to Node View Page'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushReplacement('${GraphPage.routeName}/${node.nodeId}');
              },
              child: const Text('Go to Graph Page'),
            ),
          ],
        ),
      );
    }
  }
}
