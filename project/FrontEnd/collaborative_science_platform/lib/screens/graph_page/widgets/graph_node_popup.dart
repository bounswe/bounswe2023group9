// node_details_popup.dart

import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/node_details_page/node.dart';
import 'package:go_router/go_router.dart';

class NodeDetailsPopup extends StatelessWidget {
  final Node node;

  const NodeDetailsPopup({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Node Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Title: ${node.nodeTitle}'),
          Text(
              'Contributors: ${node.contributors.map((user) => "${user.firstName} ${user.lastName} (${user.email})").join(", ")}'),
          Text('Publish Date: ${getDurationFromNow(node.publishDate)}'),
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
            context.go('${GraphPage.routeName}/${node.id}');
          },
          child: const Text('Go to Node Details'),
        ),
      ],
    );
  }
}
