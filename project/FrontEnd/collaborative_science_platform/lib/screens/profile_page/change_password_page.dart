import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/change_password_form.dart';
import 'package:collaborative_science_platform/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  static const routeName = '/change-password';
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
      appBar: SimpleAppBar(title: "Account Settings"),
      child: ChangePasswordForm(),
    );
  }
}
