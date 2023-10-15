import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final double height;

  const AppButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 2.0),
        ),
        minimumSize: Size(double.infinity, height),
      ),
      child: Text(text,
          style: TextStyle(
            fontSize: height / 3.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }
}
