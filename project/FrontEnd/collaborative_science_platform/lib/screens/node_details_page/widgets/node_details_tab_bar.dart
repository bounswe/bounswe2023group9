import 'package:collaborative_science_platform/utils/colors.dart';
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
        if (Responsive.isMobile(context))
          NavigationBarItem(
            callback: updateIndex,
            icon: Icons.people,
            index: 5,
            isSelected: currentIndex == 5,
            text: "Contributors",
          ),
      ],
    ));
  }
}

class NavigationBarItem extends StatefulWidget {
  final Function callback;
  final int index;
  final String text;
  final IconData icon;
  final bool isSelected;
  const NavigationBarItem({
    required this.callback,
    required this.icon,
    required this.index,
    required this.isSelected,
    required this.text,
    super.key,
  });

  @override
  State<NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<NavigationBarItem> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => isHovering = true),
      onExit: (event) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () => widget.callback(widget.index),
        child: Container(
          color: Colors.transparent,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      children: [
                        Icon(
                          widget.icon,
                          color: widget.isSelected
                              ? AppColors.secondaryColor
                              : isHovering
                                  ? Colors.indigo[200]
                                  : Colors.grey[700],
                        ),
                        if (!Responsive.isMobile(context))
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w700
                                    : isHovering
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                color: widget.isSelected
                                    ? AppColors.secondaryColor
                                    : isHovering
                                        ? Colors.indigo[200]
                                        : Colors.grey[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
