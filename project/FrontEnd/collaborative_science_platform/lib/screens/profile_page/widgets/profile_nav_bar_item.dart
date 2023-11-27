import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

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
