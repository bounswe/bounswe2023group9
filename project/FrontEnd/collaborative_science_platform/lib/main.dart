import 'package:collaborative_science_platform/screens/login_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart'; //delete later
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      routes: {
        '/': (context) => const LoginPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
    );
  }
}
