
import 'package:collaborative_science_platform/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      body: Container(), // Profile Page Content
    );
  }
}
