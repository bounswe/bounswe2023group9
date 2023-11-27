import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_logo.dart';
import 'package:flutter/material.dart';

class LoginPageAppBar extends StatelessWidget {
  const LoginPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppBarLogo(
          logoPath: 'assets/images/logo.svg',
          height: 60.0,
        ),
      ],
    );
  }
}
