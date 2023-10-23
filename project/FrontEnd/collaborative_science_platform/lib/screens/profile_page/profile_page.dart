import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/profile_page/components/aboutMe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData profileData = ProfileData();
  int noWorks = 0;
  bool error = false;
  String errorMessage = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      final email = Provider.of<Auth>(context).user?.email ?? "";

      final profileDataProvider =
          Provider.of<ProfileDataProvider>(context, listen: true);
      setState(() {
        isLoading = true;
      });
      await profileDataProvider.getData(email);
      setState(() {
        profileData = (profileDataProvider.profileData ?? {} as ProfileData);
        noWorks = profileData.nodeIDs.length;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    }
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AboutMe(
              aboutMe: profileData.aboutMe,
              email: profileData.email,
              name: profileData.name,
              surname: profileData.surname,
              noWorks: noWorks,
            )
          ],
        ),
      ),
    );
  }
}
