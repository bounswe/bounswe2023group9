import 'package:flutter/material.dart';

class AccountSettingsAppBar extends StatelessWidget {
  const AccountSettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded)),
            const Text("Account Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }
}
