import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final Widget profileWidget = auth.isSignedIn
        ? AppBarButton(icon: Icons.person, text: auth.user!.firstName, onPressed: () {})
        : AppBarButton(
            icon: Icons.person, text: "Login", onPressed: () => Navigator.of(context).pushNamed(LoginPage.routeName));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppBarLogo(),
        Row(children: [
          AppBarButton(icon: Icons.notifications, text: "Notifications", onPressed: () {}),
          const SizedBox(width: 10.0),
          profileWidget
        ]),
      ],
    );
  }
}
