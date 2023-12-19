import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: SizedBox(
        width: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure?', style: TextStyle(fontSize: 20.0)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      content: null,
    );
  }
}
