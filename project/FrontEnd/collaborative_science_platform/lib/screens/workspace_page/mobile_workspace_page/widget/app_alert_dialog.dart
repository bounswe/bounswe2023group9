
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String text;
  final Widget? content;
  final List<Widget>? actions;

  const AppAlertDialog({
    super.key,
    required this.text,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        width: 500,
        child: Text(
          text,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: content,
      actions: actions
    );
  }
}
