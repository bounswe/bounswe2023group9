import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double height;

  const AppTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey.shade700,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIconColor: Colors.grey,
          prefixIcon: prefixIcon,
          suffixIconColor: Colors.grey,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyanAccent),
            borderRadius: BorderRadius.circular(height/2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan.shade600),
            borderRadius: BorderRadius.circular(height/2.0),
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
