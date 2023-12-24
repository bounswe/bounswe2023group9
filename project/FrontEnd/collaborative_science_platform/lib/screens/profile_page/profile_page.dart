import 'package:collaborative_science_platform/exceptions/profile_page_exceptions.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/admin_provider.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/error_page/error_page.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/desktop_edit_profile_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/logout_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/mobile_edit_profile_button.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/profile_activity_tabbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/profile_node_card.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/question_activity.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  final String email;

  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileDataProvider profileDataProvider = ProfileDataProvider();
  ProfileData profileData = ProfileData();
  BasicUser basicUser = BasicUser();
  int noWorks = 0;
  bool error = false;
  String errorMessage = "";

  bool isLoading = false;
  bool isAuthLoading = false;
  bool _isFirstTime = true;
  int currentIndex = 0;

  int response = -1; // response status code of demote/promote
  String newUserType = ""; //new user type according to response

  int response_isBanned = -1;
  bool isBanned = false;

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      try {
        getAuthUser();
        getUserData();
      } catch (e) {
        setState(() {
          error = true;
          errorMessage = "Something went wrong!";
        });
      }
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  Future<void> getUserData() async {
    try {
      if (widget.email != "") {
        profileDataProvider = Provider.of<ProfileDataProvider>(context);
        setState(() {
          isLoading = true;
        });
        await profileDataProvider.getData(widget.email);
        setState(() {
          profileData = (profileDataProvider.profileData ?? {} as ProfileData);
          noWorks = profileData.nodes.length;
          newUserType = profileData.userType;
          isBanned = profileData.isBanned;
        });
      } else {
        final User user = Provider.of<Auth>(context).user!;
        profileDataProvider = Provider.of<ProfileDataProvider>(
            context); //This is wrong? It seems like we are taking current users data
        await profileDataProvider.getData(user.email);
        setState(() {
          profileData = (profileDataProvider.profileData ?? {} as ProfileData);
          noWorks = profileData.nodes.length;
          newUserType = profileData.userType;
        });
      }
    } on ProfileDoesNotExist {
      setState(() {
        error = true;
        errorMessage = ProfileDoesNotExist().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getAuthUser() async {
    final User? user = Provider.of<Auth>(context).user;
    if (user != null) {
      try {
        final auth = Provider.of<Auth>(context);
        basicUser = (auth.basicUser ?? {} as BasicUser);
        isAuthLoading = true;
        // user = (auth.user ?? {} as User);
      } catch (e) {
        setState(() {
          error = true;
          errorMessage = "Something went wrong!";
        });
        rethrow;
      } finally {
        setState(() {
          isAuthLoading = false;
        });
      }
    }
  }

  Future<void> changeProfileStatus() async {
    try {
      final User? admin = Provider.of<Auth>(context, listen: false).user;
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.banUser(admin, profileData.id, !profileData.isBanned);
      setState(() {
        isBanned = !isBanned;
      });
      error = false;
      var message = "Profile status updated.";
      print(message);
    } catch (e) {
      setState(() {
        error = true;
        var message = "Something went wrong!";
        print(message);
      });
    }
  }

  void handleButtonIsBanned() async {
    await changeProfileStatus();
  }

  Future<void> promoteUser() async {
    try {
      final User? admin = Provider.of<Auth>(context, listen: false).user;
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      response = await adminProvider.promoteUser(admin, profileData.id);

      error = false;
    } catch (e) {
      setState(() {
        error = true;
        var message = "Something went wrong!";
        print(message);
      });
    }
  }

  Future<void> demoteUser() async {
    try {
      final User? admin = Provider.of<Auth>(context, listen: false).user;
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      response = await adminProvider.demoteUser(admin, profileData.id);

      error = false;
    } catch (e) {
      setState(() {
        error = true;
        var message = "Something went wrong!";
        print(message);
      });
    }
  }

  void handleButtonIsReviewer() async {
    if (newUserType == "contributor") {
      await promoteUser();
      if (response == 201) {
        setState(() {
          newUserType = "reviewer";
        });
      }
    } else if (newUserType == "reviewer") {
      await demoteUser();
      if (response == 204) {
        setState(() {
          newUserType = "contributor";
        });
      }
    }
    response = -1;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<Auth>(context).user;
    var asked = profileData.askedQuestions.where((element) => element.isAnswered).toList();
    var answered = profileData.answeredQuestions.where((element) => element.isAnswered).toList();
    var questionList = asked + answered;
    if (user == null) {
      // guest can see profile pages
    } else if (user.email == profileData.email) {
      // own profile page, should be editible
      return (!profileData.isBanned || basicUser.userType == "admin")
          ? PageWithAppBar(
              appBar: const HomePageAppBar(),
              pageColor: Colors.grey.shade200,
              child: Responsive(
                mobile: SingleChildScrollView(
                  child: SizedBox(
                    width: Responsive.getGenericPageWidth(context),
                    child: isLoading && isAuthLoading
                        ? Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : error
                            ? SelectableText(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              )
                            : Column(
                                children: [
                                  AboutMe(
                                    profileData: profileData,
                                    noWorks: noWorks,
                                    userType: basicUser.userType,
                                    newUserType: newUserType,
                                    onTap: handleButtonIsBanned,
                                    onTapReviewerButton: handleButtonIsReviewer,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    child: Row(
                                      children: [
                                        const Expanded(child: MobileEditProfileButton()),
                                        Expanded(child: LogOutButton())
                                      ],
                                    ),
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
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: profileData.nodes.length,
                                          itemBuilder: (context, index) {
                                            return ProfileNodeCard(
                                              profileNode: profileData.nodes.elementAt(index),
                                              onTap: () {
                                                context.push(
                                                    '${NodeDetailsPage.routeName}/${profileData.nodes.elementAt(index).id}');
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  if (currentIndex == 1)
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: CardContainer(
                                        child: SizedBox(
                                          height: 400,
                                          child: QuestionActivity(questions: questionList),
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
                    child: isLoading
                        ? Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            padding: const EdgeInsets.only(top: 20),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : error
                            ? SelectableText(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              )
                            : Column(
                                children: [
                                  AboutMe(
                                    profileData: profileData,
                                    noWorks: noWorks,
                                    userType: basicUser.userType,
                                    newUserType: newUserType,
                                    onTap: handleButtonIsBanned,
                                    onTapReviewerButton: handleButtonIsReviewer,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: DesktopEditProfileButton(),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: ProfileActivityTabBar(
                                      callback: updateIndex,
                                    ),
                                  ),
                                  if (currentIndex == 0)
                                    CardContainer(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: profileData.nodes.length,
                                        itemBuilder: (context, index) {
                                          return ProfileNodeCard(
                                            profileNode: profileData.nodes.elementAt(index),
                                            onTap: () {
                                              context.push(
                                                  '${NodeDetailsPage.routeName}/${profileData.nodes.elementAt(index).id}');
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  if (currentIndex == 1)
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: CardContainer(
                                        child: SizedBox(
                                          height: 400,
                                          child: QuestionActivity(questions: questionList),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                  ),
                ),
              ),
            )
          : const ErrorPage();
    }

    // others profile page, will be same both on desktop and mobile
    return (!profileData.isBanned || basicUser.userType == "admin")
        ? PageWithAppBar(
            appBar: const HomePageAppBar(),
            pageColor: Colors.grey.shade200,
            child: SingleChildScrollView(
              child: SizedBox(
                width: Responsive.getGenericPageWidth(context),
                child: isLoading && isAuthLoading
                    ? Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.only(top: 20),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : error
                        ? SelectableText(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AboutMe(
                                  profileData: profileData,
                                  noWorks: noWorks,
                                  userType: basicUser.userType,
                                  newUserType: newUserType,
                                  onTap: handleButtonIsBanned,
                                  onTapReviewerButton: handleButtonIsReviewer),
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
                                      padding: const EdgeInsets.all(0),
                                      physics:
                                          const NeverScrollableScrollPhysics(), // Prevents a conflict with SingleChildScrollView
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: profileData.nodes.length,
                                      itemBuilder: (context, index) {
                                        return ProfileNodeCard(
                                          profileNode: profileData.nodes.elementAt(index),
                                          onTap: () {
                                            context.push(
                                                '${NodeDetailsPage.routeName}/${profileData.nodes.elementAt(index).id}');
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              if (currentIndex == 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: CardContainer(
                                    child: SizedBox(
                                      height: 400,
                                      child: QuestionActivity(questions: questionList),
                                    ),
                                  ),
                                ),
                            ],
                          ),
              ),
            ),
          )
        : const ErrorPage();
  }
}
