import 'dart:html';

import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// TODO: add tabbar, PageWithTabBar() gives error, check it out
// TODO: connect NodeTab and QuestionTab to profileData
// TODO: add optional parameter to ProfilePage to show others profile page
// TODO: fix overflow on mobile for About Me section
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
        print(profileData);
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
    final User? user = Provider.of<Auth>(context).user;
    if (user == null) {
      // guest can see profile pages
    } else if (user.email == "omer.unal@boun.edu.tr") {
      // own profile page, should be editible
      return DefaultTabController(
        length: 2, // Number of tabs
        child: Responsive(
          desktop: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AboutMe(
                        aboutMe: profileData.aboutMe,
                        email: profileData.email,
                        name: profileData.name,
                        surname: profileData.surname,
                        noWorks: noWorks,
                      ),
                      MyPadding(),
                      EditProfileWeb(),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ProfileTabbar(
                  child: Container(),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                NodeTab(),
                QuestionTab(),
              ],
            ),
          ),
          mobile: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AboutMe(
                        aboutMe: profileData.aboutMe,
                        email: profileData.email,
                        name: profileData.name,
                        surname: profileData.surname,
                        noWorks: noWorks,
                      ),
                      MyPadding(),
                      EditProfileMobile(),
                      MyPadding(),
                      LogOutMobile()
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ProfileTabbar(
                  child: Container(),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                NodeTab(),
                QuestionTab(),
              ],
            ),
          ),
        ),
      );
    }

    // others profile page, will be same both on desktop and mobile
    return DefaultTabController(
      length: 2, // Number of tabs
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AboutMe(
                    aboutMe: profileData.aboutMe,
                    email: profileData.email,
                    name: profileData.name,
                    surname: profileData.surname,
                    noWorks: noWorks,
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: ProfileTabbar(
              child: Container(),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            NodeTab(),
            QuestionTab(),
          ],
        ),
      ),
    );
  }
}

class EditProfileWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Show Popup with EditProfileForm content
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: SizedBox(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Edit Profile',
                              style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    content: EditProfileForm(),
                  ));
        },
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10.0),
              Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Show Popup with EditProfileForm content
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: SizedBox(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Edit Profile',
                              style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    content: EditProfileForm(),
                  ));
        },
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10.0),
              Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class LogOutMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTabbar extends SliverPersistentHeaderDelegate {
  final Widget child;

  ProfileTabbar({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,
      child: TabBar(
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        tabs: [
          Tab(
            icon: Icon(
              Icons.account_tree_rounded, // represents Node
              color: Colors.black,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.question_answer_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 48;

  @override
  // TODO: implement minExtent
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class NodeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 10, // Replace with the desired number of items
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Nodes Tab Content $index'),
          );
        },
      ),
    );
  }
}

class QuestionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 10, // Replace with the desired number of items
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Questions Tab Content $index'),
          );
        },
      ),
    );
  }
}

class MyPadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Divider(height: 40.0),
    );
  }
}
