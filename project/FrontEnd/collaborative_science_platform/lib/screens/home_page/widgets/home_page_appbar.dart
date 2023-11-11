import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/profile_menu.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_logo.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const TopNavigationBar(),
      desktop: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppBarLogo(height: 50.0),
            const TopNavigationBar(),
            Row(children: [
              if (!Responsive.isMobile(context))
                AppBarButton(icon: Icons.notifications, text: "Notifications", onPressed: () {}),
              const SizedBox(width: 10.0),
              const ProfileMenu(),
            ]),
          ],
        ),
      ),
    );
  }
}
