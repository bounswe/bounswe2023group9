import 'package:collaborative_science_platform/screens/profile_page/widgets/profile_nav_bar_item.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ProfileActivityTabBar extends StatefulWidget {
  final Function callback;
  const ProfileActivityTabBar({
    super.key,
    required this.callback,
  });
  @override
  State<ProfileActivityTabBar> createState() => _ProfileActivityTabBar();
}

class _ProfileActivityTabBar extends State<ProfileActivityTabBar> {
  int currentIndex = 0;

  void updateIndex(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
    widget.callback(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            "Activities",
            style: TextStyles.bodyBlack,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavigationBarItem(
              callback: updateIndex,
              icon: Icons.content_copy,
              index: 0,
              text: "Published Nodes",
              isSelected: currentIndex == 0,
            ),
            NavigationBarItem(
              callback: updateIndex,
              icon: Icons.question_answer,
              index: 1,
              isSelected: currentIndex == 1,
              text: "Q/A",
            ),
          ],
        ),
      ],
    ));
  }
}
