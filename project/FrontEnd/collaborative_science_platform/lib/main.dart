import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/home_page.dart';
import 'package:collaborative_science_platform/screens/login_page.dart';
import 'package:collaborative_science_platform/screens/profile_page.dart';
import 'package:collaborative_science_platform/screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<Auth>( create: (context) => Auth())],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        routes: {
          '/': (context) => const LoginPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          HomePage.routeName: (context) => const HomePage(),
          WorkspacesPage.routeName: (context) => const WorkspacesPage(),  // May not be needed
          ProfilePage.routeName: (context) => const ProfilePage(),        // May not be needed
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
      ),
    );
  }
}
