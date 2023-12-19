import 'package:collaborative_science_platform/exceptions/profile_page_exceptions.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
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

// TODO: add optional parameter to ProfilePage to get others profileData
class _ProfilePageState extends State<ProfilePage> {
  ProfileData profileData = ProfileData();
  BasicUser basicUser = BasicUser();
  int noWorks = 0;
  bool error = false;
  String errorMessage = "";
  bool isLoading = false;
  bool isAuthLoading = false;

  bool _isFirstTime = true;

  bool isBanned = false;
  bool isValidUser = false; //visited user's type is contributor or reviewer
  bool isReviewer = false;

  int currentIndex = 0;

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

  void getUserData() async {
    try {
      if (widget.email != "") {
        final profileDataProvider = Provider.of<ProfileDataProvider>(context);
        setState(() {
          isLoading = true;
        });
        await profileDataProvider.getData(widget.email);
        setState(() {
          profileData = (profileDataProvider.profileData ?? {} as ProfileData);
          noWorks = profileData.nodes.length;
        });
      } else {
        final User user = Provider.of<Auth>(context).user!;
        final profileDataProvider = Provider.of<ProfileDataProvider>(context);
        await profileDataProvider.getData(user.email);
        setState(() {
          profileData = (profileDataProvider.profileData ?? {} as ProfileData);
          noWorks = profileData.nodes.length;
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

  void handleButtonIsBanned() {
    setState(() {
      isBanned = !isBanned; // Toggle the state for example purposes
    });
  }

  void handleButtonIsReviewer() {
    setState(() {
      isReviewer = !isReviewer; // Toggle the state for example purposes
    });
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
      return (!isBanned || basicUser.userType == "admin")
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
                                    aboutMe: profileData.aboutMe,
                                    email: profileData.email,
                                    name: profileData.name,
                                    surname: profileData.surname,
                                    noWorks: noWorks,
                                    isBanned: isBanned,
                                    isReviewer: isReviewer,
                                    isValidUser: isValidUser,
                                    userType: basicUser.userType,
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
                                    aboutMe: profileData.aboutMe,
                                    email: profileData.email,
                                    name: profileData.name,
                                    surname: profileData.surname,
                                    noWorks: noWorks,
                                    isBanned: isBanned,
                                    isReviewer: isReviewer,
                                    isValidUser: isValidUser,
                                    userType: basicUser.userType,
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
    return (!isBanned || basicUser.userType == "admin")
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
                                  aboutMe: profileData.aboutMe,
                                  email: profileData.email,
                                  name: profileData.name,
                                  surname: profileData.surname,
                                  noWorks: noWorks,
                                  isBanned: isBanned,
                                  isReviewer: isReviewer,
                                  isValidUser: isValidUser,
                                  userType: basicUser.userType,
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
