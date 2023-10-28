import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/profile_menu.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_logo.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const TopNavigationBar(),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppBarLogo(),
          const TopNavigationBar(),
          Row(children: [
            if (!Responsive.isMobile(context))
              AppBarButton(icon: Icons.notifications, text: "Notifications", onPressed: () {}),
            const SizedBox(width: 10.0),
            const ProfileMenu()
          ]),
        ],
      ),
    );
  }
}
