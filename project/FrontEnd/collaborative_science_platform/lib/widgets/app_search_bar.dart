import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final Function() onSearch;
  final FocusNode focusNode;
  final TextEditingController controller;
  const AppSearchBar({required this.onSearch, required this.controller, required this.focusNode, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onSearch,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                width: 38,
                height: 38,
                child: Icon(
                  Icons.search,
                  color: Colors.indigo[500],
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]!),
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
