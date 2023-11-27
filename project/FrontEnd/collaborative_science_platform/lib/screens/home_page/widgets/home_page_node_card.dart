import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePageNodeCard extends StatelessWidget {
  final Node smallNode;
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
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: onTap,
                  child: Text(
                    smallNode.nodeTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: AppColors.primaryDarkColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SelectableText(
                smallNode.contributors
                    .map((user) => "${user.firstName} ${user.lastName} (${user.email})")
                    .join(", "),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.0,
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
    );
  }
}
