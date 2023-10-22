import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String textType;
  final String textContent;
  final Icon prefixIcon;

  const SettingsWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textType,
    required this.textContent,
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
              prefixIcon,
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
                  style: const TextStyle(
                      color: AppColors.primaryColor, fontSize: 14.0),
                ),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: null,
                  keyboardType: TextInputType.text,
                  cursorColor: AppColors.primaryColor,
                  maxLines: null, // Allow the input to have multiple lines

                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                      ), // Color of the line
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors
                              .secondaryDarkColor), // Color of the line when focused
                    ),
                    isCollapsed:
                        true, // This makes the input and hint text closer
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: textContent,
                    hintMaxLines: null,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 18.0),
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
