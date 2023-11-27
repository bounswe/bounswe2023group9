import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class SuggestionNodeCard extends StatelessWidget {
  final Node smallNode;
  final Color? color;
  final Function() onTap;

  const SuggestionNodeCard({
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
      color: Colors.white,
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
              SelectableText(
                smallNode.nodeTitle,
                onTap: onTap,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 10.0, color: AppColors.primaryDarkColor),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    getDurationFromNow(smallNode.publishDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
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
