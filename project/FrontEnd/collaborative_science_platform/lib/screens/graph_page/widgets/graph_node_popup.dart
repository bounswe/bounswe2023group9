// node_details_popup.dart

import 'dart:ui';

import 'package:collaborative_science_platform/exceptions/node_details_exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/widgets/annotation_text.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
          title: const Text('Node Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnnotationText('Title: ${node.nodeTitle}'),
              Text(
                  'Contributors: ${node.contributors.map((user) => "${user.firstName} ${user.lastName} (${user.email})").join(", ")}'),
              Text('Publish Date: ${getDurationFromNow(node.publishDate!)}'),
              AnnotationText('Theorem Content: ${node.theorem?.theoremContent ?? "No theorem"}'),
            ],
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