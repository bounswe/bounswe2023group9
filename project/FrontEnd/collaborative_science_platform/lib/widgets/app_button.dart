import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double height;
  final void Function() onTap;
  final bool isActive;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.height,
    required this.onTap,
    this.isActive = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onTap : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppColors.primaryColor : Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 2.0),
        ),
        minimumSize: Size(double.infinity, height),
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Text(text,
              style: TextStyle(
                fontSize: height / 3.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
    );
  }
}
