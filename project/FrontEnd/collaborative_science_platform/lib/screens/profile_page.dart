import 'package:collaborative_science_platform/widgets/aboutMe.dart';
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
      //bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AboutMe(
              userId: "USERID SHOULD BE PROVIDED HERE",
            )
          ],
        ),
      ),
    );
  }
}
