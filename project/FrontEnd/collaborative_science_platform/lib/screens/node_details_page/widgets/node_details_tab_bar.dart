import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details_nav_bar_item.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class NodeDetailsTabBar extends StatefulWidget {
  final Function callback;
  const NodeDetailsTabBar({
    super.key,
    required this.callback,
  });
  @override
  State<NodeDetailsTabBar> createState() => _NodeDetailsTabBarState();
}

class _NodeDetailsTabBarState extends State<NodeDetailsTabBar> {
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
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NavigationBarItem(
          callback: updateIndex,
          icon: Icons.my_library_books,
          index: 0,
          text: "Theorem",
          isSelected: currentIndex == 0,
        ),
        NavigationBarItem(
          callback: updateIndex,
          icon: Icons.manage_search,
          index: 1,
          text: "Proofs",
          isSelected: currentIndex == 1,
        ),
        NavigationBarItem(
          callback: updateIndex,
          icon: Icons.import_contacts,
          index: 2,
          text: "References",
          isSelected: currentIndex == 2,
        ),
        NavigationBarItem(
          callback: updateIndex,
          icon: Icons.format_quote,
          index: 3,
          text: "Citations",
          isSelected: currentIndex == 3,
        ),
        NavigationBarItem(
          callback: updateIndex,
          icon: Icons.question_answer,
          index: 4,
          isSelected: currentIndex == 4,
          text: "Q/A",
        ),
        if (!Responsive.isDesktop(context))
          NavigationBarItem(
            callback: updateIndex,
            icon: Icons.people,
            index: 5,
            isSelected: currentIndex == 5,
            text: "Contributors",
          ),
        if (!Responsive.isDesktop(context))
          NavigationBarItem(
            callback: updateIndex,
            icon: Icons.tag,
            index: 6,
            isSelected: currentIndex == 6,
            text: "Contributors",
          ),
      ],
    ));
  }
}
