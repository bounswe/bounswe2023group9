import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:flutter/material.dart';

class GraphNodeCard extends StatelessWidget {
  final Node node;
  final Color? color;
  final Function() onTap;

  const GraphNodeCard({
    Key? key,
    required this.node,
    this.color,
    required this.onTap,
  }) : super(key: key);

  String getContributorsText(List<User> contributors) {
    return contributors
        .map((user) => "${user.firstName} ${user.lastName} (${user.email})")
        .join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Increased border radius
      ),
      child: Card(
        elevation: 4, // Added elevation for a material-like appearance
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Adjusted padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                node.nodeTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0, // Increased font size for title
                ),
              ),
              const SizedBox(height: 8.0), // Increased spacing
              SelectableText(
                getContributorsText(node.contributors),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0), // Increased spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjusted alignment
                children: [
                  SelectableText(
                    getDurationFromNow(node.publishDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward, // Added an arrow icon for indication
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
}
