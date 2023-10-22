import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_logo.dart';
import 'package:flutter/material.dart';

class LoginPageAppBar extends StatelessWidget {
  const LoginPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppBarLogo(),
      ],
    );
  }
}
