import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/profile_menu.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_logo.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: TopNavigationBar(),
      desktop: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBarLogo(height: 50.0),
            TopNavigationBar(),
            Row(children: [
              // if (!Responsive.isMobile(context))
              //   AppBarButton(
              //       icon: Icons.notifications,
              //       text: "Notifications",
              //       onPressed: () {
              //         context.push(NotificationPage.routeName);
              //       }),
              // const SizedBox(width: 10.0),
              ProfileMenu(),
            ]),
          ],
        ),
      ),
    );
  }
}
