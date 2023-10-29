import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/desktop_edit_profile.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/mobile_edit_profile.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/profile_activity_tabbar.dart';
import 'package:collaborative_science_platform/utils/textStyles.dart';
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

// TODO: connect NodeActivity and QuestionActivity to profileData
// TODO: add optional parameter to ProfilePage to get others profileData
// TODO: make NodeTab clickable which directs to NodeDetailsPage
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
    print(currentIndex);
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: MobileEditProfile(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: MobileLogOut(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ProfileActivityTabBar(
                      callback: updateIndex,
                    ),
                  ),
                  if (currentIndex == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: Container(
                          height: 400,
                          child: NodeActivity(),
                        ),
                      ),
                    ),
                  if (currentIndex == 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: Container(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: DesktopEditProfile(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ProfileActivityTabBar(
                      callback: updateIndex,
                    ),
                  ),
                  if (currentIndex == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: Container(
                          height: 400,
                          child: NodeActivity(),
                        ),
                      ),
                    ),
                  if (currentIndex == 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CardContainer(
                        child: Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ProfileActivityTabBar(
                  callback: updateIndex,
                ),
              ),
              if (currentIndex == 0)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CardContainer(
                    child: Container(
                      height: 400,
                      child: NodeActivity(),
                    ),
                  ),
                ),
              if (currentIndex == 1)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CardContainer(
                    child: Container(
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

class MobileLogOut extends StatelessWidget {
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

class NodeActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 10, // Replace with the desired number of items
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title:
                Text('Nodes Tab Content $index', style: TextStyles.bodyBlack),
          );
        },
      ),
    );
  }
}

class QuestionActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 10, // Replace with the desired number of items
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Questions Tab Content $index',
                style: TextStyles.bodyBlack),
          );
        },
      ),
    );
  }
}
