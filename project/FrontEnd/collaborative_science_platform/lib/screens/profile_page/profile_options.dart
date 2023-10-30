import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileOptions extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<Auth>(context).user;
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      child: Responsive(
        mobile: user != null ? MobileProfileOptions(user: user) : const PleaseLoginPage(),
        desktop: user != null ? DesktopProfileOptions(user: user) : const PleaseLoginPage(),
      ),
    );
  }
}

class DesktopProfileOptions extends StatelessWidget {
  const DesktopProfileOptions({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: Responsive.getGenericPageWidth(context),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                      border: Border.all(color: Colors.white, width: 6.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text('${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Divider(height: 40.0),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend ',
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.email, color: Colors.grey, size: 30.0),
                      const SizedBox(width: 10.0),
                      Text(user.email, style: const TextStyle(fontSize: 16.0))
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  const Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.book_fill, color: Colors.grey, size: 30.0),
                      SizedBox(width: 10.0),
                      Text('1234 works published', style: TextStyle(fontSize: 16.0))
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            MouseRegion(
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
                                  Text('Edit Profile', style: TextStyle(fontSize: 20.0)),
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
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 10.0),
                      Text('Edit Profile',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Divider(height: 40.0),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileProfileOptions extends StatelessWidget {
  const MobileProfileOptions({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: Responsive.getGenericPageWidth(context),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                      border: Border.all(color: Colors.white, width: 6.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text('${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Divider(height: 40.0),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend ',
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.email, color: Colors.grey, size: 30.0),
                      const SizedBox(width: 10.0),
                      Text(user.email, style: const TextStyle(fontSize: 16.0))
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  const Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.book_fill, color: Colors.grey, size: 30.0),
                      SizedBox(width: 10.0),
                      Text('1234 works published', style: TextStyle(fontSize: 16.0))
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AccountSettingsPage.routeName);
                },
                child: Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 10.0),
                      Text('Edit Profile',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Divider(height: 40.0),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.pushNamed(context, PleaseLoginPage2.routeName);
                },
                child: Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Logout',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PleaseLoginPage extends StatelessWidget {
  const PleaseLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.getGenericPageWidth(context),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Divider(height: 40.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Text("To be able to see your profile, please login!"),
              const SizedBox(height: 5),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, LoginPage.routeName),
                  child: Container(
                    height: 40.0,
                    width: 160,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Login',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text("If you don't have an account please signup!"),
              const SizedBox(height: 5),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, SignUpPage.routeName),
                  child: Container(
                    height: 40.0,
                    width: 160,
                    decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5.0)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Signup',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Divider(height: 40.0),
          ),
        ],
      ),
    );
  }
}
