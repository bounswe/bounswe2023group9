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
    return SizedBox(
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.cyan.shade800,
            borderRadius: BorderRadius.circular(height/2.0),
            border: Border.all(color: Colors.white54),
          ),
          child: Center(
            child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: height/3.0,
                )
            ),
          ),
        ),
      ),
    );
  }
}
