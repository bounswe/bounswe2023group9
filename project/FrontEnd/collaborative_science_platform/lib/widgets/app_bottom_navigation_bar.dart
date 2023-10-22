import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        String routeName = (index == 0)
            ? HomePage.routeName
            : (index == 1)
                ? WorkspacesPage.routeName
                : ProfilePage.routeName;
        Navigator.pushNamed(context, routeName);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: "Workspaces",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
