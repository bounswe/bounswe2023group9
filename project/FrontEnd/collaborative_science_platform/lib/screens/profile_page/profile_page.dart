import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_button.dart';
import 'package:flutter/cupertino.dart';
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

  bool _isFirstTime = true;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getUserData();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getUserData() async {
    try {
      final User user = Provider.of<Auth>(context).user!;
      final profileDataProvider = Provider.of<ProfileDataProvider>(context);
      setState(() {
        isLoading = true;
      });
      await profileDataProvider.getData(user);
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
    return PageWithAppBar(
      appBar: Row(children: [AppBarButton(icon: CupertinoIcons.back, text: "Back", onPressed: () {})]),
      //bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
