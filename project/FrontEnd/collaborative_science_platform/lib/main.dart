import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/node_details_provider.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
//import 'package:collaborative_science_platform/screens/notifications_page.dart';
import 'package:collaborative_science_platform/screens/notifications_page/notifications_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/workspaces_page.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
        ChangeNotifierProvider<ProfileDataProvider>(create: (context) => ProfileDataProvider()),
        ChangeNotifierProvider<NodeDetailsProvider>(create: (context) => NodeDetailsProvider()),
        ChangeNotifierProvider<NodeProvider>(create: (context) => NodeProvider()),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
      ],
  //    child: MaterialApp(
  //      debugShowCheckedModeBanner: false,
  //      title: Constants.appName,
  //      routes: {
  //        '/': (context) => const HomePage(),
  //        LoginPage.routeName: (context) => const LoginPage(),
  //        SignUpPage.routeName: (context) => const SignUpPage(),
  //        WorkspacesPage.routeName: (context) => const WorkspacesPage(),
//
  //        ///ProfilePage.routeName: (context) => const ProfilePage(),
  //        GraphPage.routeName: (context) => const GraphPage(),
  //        NotificationPage.routeName: (context) => const NotificationPage(),
  //        AccountSettingsPage.routeName: (context) => const AccountSettingsPage(),
  //        PleaseLoginPage2.routeName: (context) => const PleaseLoginPage2(),
  //        NodeDetailsPage.routeName: (context) {
  //          final int nodeId = ModalRoute.of(context)!.settings.arguments as int;
  //          return NodeDetailsPage(nodeID: nodeId);
  //        },
  //        ProfilePage.routeName: (context) {
  //          final String email = ModalRoute.of(context)!.settings.arguments as String ?? "";
  //          return ProfilePage(email: email);
  //        },
  //      },
  //      navigatorKey: ScreenNavigation.navigatorKey,
  //      theme: ThemeData(
  //        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  //        useMaterial3: true,
  //      ),
      child: MaterialApp.router(
        routerConfig: _router,
        // debugShowCheckedModeBanner: false,
        // title: Constants.appName,
        // navigatorKey: ScreenNavigation.navigatorKey,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        //   useMaterial3: true,
        // ),
      ),
    );
  }
}

// GoRouter configuration
final _router = GoRouter(
  navigatorKey: ScreenNavigation.navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      name:
          'home', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: LoginPage.routeName.substring(1),
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: SignUpPage.routeName.substring(1),
      path: SignUpPage.routeName,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      name: WorkspacesPage.routeName.substring(1),
      path: WorkspacesPage.routeName,
      builder: (context, state) => const WorkspacesPage(),
    ),
    GoRoute(
      name: GraphPage.routeName.substring(1),
      path: GraphPage.routeName,
      builder: (context, state) => const GraphPage(),
    ),
    GoRoute(
      name: NotificationPage.routeName.substring(1),
      path: NotificationPage.routeName,
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      name: AccountSettingsPage.routeName.substring(1),
      path: AccountSettingsPage.routeName,
      builder: (context, state) => const AccountSettingsPage(),
    ),
    GoRoute(
      name: PleaseLoginPage2.routeName.substring(1),
      path: PleaseLoginPage2.routeName,
      builder: (context, state) => const PleaseLoginPage2(),
    ),
    GoRoute(
      name: NodeDetailsPage.routeName.substring(1),
      path: "${NodeDetailsPage.routeName}/:nodeId",
      builder: (context, state) {
        final int nodeId = int.tryParse(state.pathParameters['nodeId'] ?? '') ?? 0;
        return NodeDetailsPage(nodeID: nodeId);
      },
    ),
    GoRoute(
        name: ProfilePage.routeName.substring(1),
        path: "${ProfilePage.routeName}/:email",
        builder: (context, state) {
          final String encodedEmail = state.pathParameters['email'] ?? '';
          final String email = Uri.decodeComponent(encodedEmail);
          return ProfilePage(email: email);
        }),
  ],
);
