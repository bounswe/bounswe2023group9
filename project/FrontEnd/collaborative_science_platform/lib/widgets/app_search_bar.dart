
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double height;
  final void Function(String)? onChanged;
  final bool isActive;


  const AppSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.height,
    this.onChanged,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    double borderWidth = 3.0;
    return SizedBox(
        height: height,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          keyboardType: TextInputType.text,
          cursorColor: Colors.grey.shade700,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            suffixIconColor: Colors.white,
            suffixIcon: CircleAvatar(
              backgroundColor: isActive ? AppColors.primaryColor : Colors.grey.shade600,
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: isActive ? () { /* Search the input text */ } : null,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: borderWidth,
                  color: isActive ? AppColors.primaryColor : Colors.grey.shade600
              ),
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: borderWidth,
                  color: isActive ? AppColors.primaryColor : Colors.grey.shade600
              ),
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
    );
  }
}
