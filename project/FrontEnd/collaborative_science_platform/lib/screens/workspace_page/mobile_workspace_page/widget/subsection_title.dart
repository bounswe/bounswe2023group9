import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class SubSectionTitle extends StatelessWidget {
  final String title;
  const SubSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.secondaryDarkColor,
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
        ),
      ),
    );
  }
}


