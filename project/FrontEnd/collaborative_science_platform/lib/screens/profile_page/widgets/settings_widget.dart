import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String textType;
  final IconData prefixIcon;

  const SettingsWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textType,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Icon(prefixIcon, color: Colors.grey),
              const SizedBox(height: 5.0),
            ],
          ),
          const SizedBox(width: 13.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textType,
                  style: const TextStyle(color: AppColors.primaryColor, fontSize: 14.0),
                ),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: null,
                  keyboardType: TextInputType.text,
                  cursorColor: AppColors.primaryColor,
                  maxLines: null, // Allow the input to have multiple lines
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                      ), // Color of the line
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryDarkColor), // Color of the line when focused
                    ),
                    isCollapsed: true, // This makes the input and hint text closer
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    fillColor: Colors.white,
                    filled: true,
                    hintMaxLines: null,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                ),
                //textContent,
                const SizedBox(height: 3.0),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
        ],
      ),
    );
  }
}
