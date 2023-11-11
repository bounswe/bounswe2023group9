import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/account_settings_form.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_appbar.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  static const routeName = '/account-settings';
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
      appBar: AccountSettingsAppBar(),
      child: AccountSettingsForm(),
    );
  }
}

