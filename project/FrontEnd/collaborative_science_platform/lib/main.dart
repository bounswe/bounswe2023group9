import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart'; //delete later
import 'package:collaborative_science_platform/screens/builder_page.dart';
import 'package:collaborative_science_platform/screens/graph_page.dart';
import 'package:collaborative_science_platform/screens/notifications_page.dart';
import 'package:collaborative_science_platform/screens/profile_options.dart';
import 'package:collaborative_science_platform/screens/workspaces_page.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
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
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<ScreenNavigation>(create: (context) => ScreenNavigation()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        routes: {
          '/': (context) => const BuilderPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          WorkspacesPage.routeName: (context) => const WorkspacesPage(),
          ProfileOptions.routeName: (context) => const ProfileOptions(),
          GraphPage.routeName: (context) => const GraphPage(),
          NotificationPage.routeName: (context) => const NotificationPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
      ),
    );
  }
}
