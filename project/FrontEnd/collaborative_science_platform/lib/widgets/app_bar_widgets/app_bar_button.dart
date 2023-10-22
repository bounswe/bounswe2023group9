import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final String text;
  const AppBarButton({super.key, required this.icon, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: mobile(), desktop: desktop());
  }

  Widget desktop() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.grey[100],
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      ),
      child: Row(
        children: [
          Icon(icon),
          Text(text),
        ],
      ),
    );
  }

  Widget mobile() {
    return IconButton(onPressed: onPressed, icon: Icon(icon));
  }
}
