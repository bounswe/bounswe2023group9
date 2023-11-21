import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:flutter/material.dart';

class GraphNodeCard extends StatefulWidget {
  final Node node;
  final Color? color;
  final Function() onTap;

  const GraphNodeCard({
    Key? key,
    required this.node,
    this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GraphNodeCard> createState() => _GraphNodeCardState();
}

class _GraphNodeCardState extends State<GraphNodeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                widget.node.nodeTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0), // Increased spacing
              SelectableText(
                getContributorsText(widget.node.contributors),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    getDurationFromNow(widget.node.publishDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getContributorsText(List<User> contributors) {
    return contributors
        .map((user) => "${user.firstName} ${user.lastName} (${user.email})")
        .join(", ");
  }
}
