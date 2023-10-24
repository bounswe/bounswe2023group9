
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePageNode extends StatelessWidget {
  final String nodeTitle;
  final String nodeContent;
  final Function() onTap;

  const HomePageNode({
    super.key,
    required this.nodeTitle,
    required this.nodeContent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap, // Navigate to the Screen of the Node
        child: Card(
          color: AppColors.primaryLightColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nodeTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nodeContent,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
