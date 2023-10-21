import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final String textType;
  final Text textContent;
  final Icon prefixIcon;
  final IconButton suffixIcon;

  const SettingsWidget({
    super.key,
    required this.textType,
    required this.textContent,
    required this.prefixIcon,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            prefixIcon,
            const SizedBox(height: 5.0),
          ]),
          //Padding(padding: const EdgeInsets.all(5.0), child: prefixIcon),
          const SizedBox(width: 13.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textType,
                    style: const TextStyle(
                        color: AppColors.primaryColor, fontSize: 14.0),
                  ),
                  textContent,
                  const SizedBox(height: 3.0),
                ],
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(5.0), child: suffixIcon),
        ],
      ),
    );
  }
}
