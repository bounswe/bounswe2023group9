import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/graph_page.dart';
import 'package:collaborative_science_platform/screens/notifications_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
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
        ChangeNotifierProvider<ScreenNavigation>(
            create: (context) => ScreenNavigation()),
        ChangeNotifierProvider<ProfileDataProvider>(
            create: (context) => ProfileDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        routes: {
          '/': (context) => const HomePage(),
          LoginPage.routeName: (context) => const LoginPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          WorkspacesPage.routeName: (context) => const WorkspacesPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          GraphPage.routeName: (context) => const GraphPage(),
          NotificationPage.routeName: (context) => const NotificationPage(),
          AccountSettingsPage.routeName: (context) =>
              const AccountSettingsPage(),
        },
        navigatorKey: ScreenNavigation.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
      ),
    );
  }
}
