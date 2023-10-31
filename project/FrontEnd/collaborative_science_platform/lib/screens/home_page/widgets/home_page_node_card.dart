import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:flutter/material.dart';

class HomePageNodeCard extends StatelessWidget {
  final SmallNode smallNode;
  final Color? color;
  final Function() onTap;

  const HomePageNodeCard({
    super.key,
    required this.smallNode,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap, // Navigate to the screen of the Node
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                smallNode.nodeTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                smallNode.contributors
                    .map((user) =>
                        "${user.name} ${user.surname} (${user.email})")
                    .join(", "),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    getDurationFromNow(smallNode.publishDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 12.0),
              // Text(
              //   smallNode.theorem,
              //   maxLines: 4,
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyle(
              //     fontSize: 14.0,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
