import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  static const routeName = '/notifications';
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
        appBar: HomePageAppBar(), child: Text("Notifications")); // Profile Page Content
  }
}
