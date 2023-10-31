import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/desktop_edit_profile_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/logout_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/mobile_edit_profile_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/profile_activity_tabbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/profile_node_card.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// TODO: add optional parameter to ProfilePage to get others profileData
class _ProfilePageState extends State<ProfilePage> {
  ProfileData profileData = ProfileData();
  int noWorks = 0;
  bool error = false;
  String errorMessage = "";
  bool isLoading = false;

  bool _isFirstTime = true;

  int currentIndex = 0;

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

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
      await profileDataProvider.getData(user.email);
      setState(() {
        profileData = (profileDataProvider.profileData ?? {} as ProfileData);
        noWorks = profileData.nodes.length;
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
    } else if (user.email == profileData.email) {
      // own profile page, should be editible
      return PageWithAppBar(
        appBar: const HomePageAppBar(),
        pageColor: Colors.grey.shade200,
        child: Responsive(
          mobile: SingleChildScrollView(
            child: SizedBox(
              width: Responsive.getGenericPageWidth(context),
              child: Column(
                children: [
                  AboutMe(
                    aboutMe: profileData.aboutMe,
                    email: profileData.email,
                    name: profileData.name,
                    surname: profileData.surname,
                    noWorks: noWorks,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      children: [const Expanded(child: MobileEditProfileButton()), Expanded(child: LogOutButton())],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ProfileActivityTabBar(
                      callback: updateIndex,
                    ),
                  ),
                  if (currentIndex == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: profileData.nodes.length,
                          itemBuilder: (context, index) {
                            return ProfileNodeCard(
                              profileNode: profileData.nodes.elementAt(index),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ),
                  if (currentIndex == 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: SizedBox(
                          height: 400,
                          child: QuestionActivity(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          desktop: SingleChildScrollView(
            child: SizedBox(
              width: Responsive.getGenericPageWidth(context),
              child: Column(
                children: [
                  AboutMe(
                    aboutMe: profileData.aboutMe,
                    email: profileData.email,
                    name: profileData.name,
                    surname: profileData.surname,
                    noWorks: noWorks,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: DesktopEditProfileButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ProfileActivityTabBar(
                      callback: updateIndex,
                    ),
                  ),
                  if (currentIndex == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: profileData.nodes.length,
                          itemBuilder: (context, index) {
                            return ProfileNodeCard(
                              profileNode: profileData.nodes.elementAt(index),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ),
                  if (currentIndex == 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: SizedBox(
                          height: 400,
                          child: QuestionActivity(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // others profile page, will be same both on desktop and mobile
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      pageColor: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: SizedBox(
          width: Responsive.getGenericPageWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AboutMe(
                aboutMe: profileData.aboutMe,
                email: profileData.email,
                name: profileData.name,
                surname: profileData.surname,
                noWorks: noWorks,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ProfileActivityTabBar(
                  callback: updateIndex,
                ),
              ),
              if (currentIndex == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CardContainer(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Prevents a conflict with SingleChildScrollView
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: profileData.nodes.length,
                      itemBuilder: (context, index) {
                        return ProfileNodeCard(
                          profileNode: profileData.nodes.elementAt(index),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ),
              if (currentIndex == 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CardContainer(
                    child: SizedBox(
                      height: 400,
                      child: QuestionActivity(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: currently no API to get questions
class QuestionActivity extends StatelessWidget {
  const QuestionActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            // onTap: Navigate to the screen of the question/answer
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "question/answer $index",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 8.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'some date',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
