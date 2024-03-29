import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String textType;
  final IconData prefixIcon;
  final double widgetWidth;
  final Function controllerCheck;

  const SettingsWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textType,
    required this.prefixIcon,
    required this.widgetWidth,
    required this.controllerCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Wrap the container with a Card
      elevation: 2, // Add elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: widgetWidth,
        padding: const EdgeInsets.symmetric(horizontal: 4),
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
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    textType,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14.0,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (_) {controllerCheck();},
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.secondaryDarkColor,
                        ), // Color of the line when focused
                      ),
                      isCollapsed:
                          true, // This makes the input and hint text closer
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      fillColor: Colors.white,
                      filled: true,
                      hintMaxLines: null,
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }
}
