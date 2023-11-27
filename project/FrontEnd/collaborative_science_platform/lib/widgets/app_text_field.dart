import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool obscureText;
  final double height;
  final Color color;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final int maxLines;
  final TextInputType? textInputType;

  const AppTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.obscureText,
    required this.height,
    this.color = AppColors.primaryColor,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        onChanged: onChanged,
        keyboardType: textInputType,
        cursorColor: Colors.grey.shade700,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIconColor: Colors.grey,
          prefixIcon: prefixIcon,
          suffixIconColor: Colors.grey,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.secondaryDarkColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
