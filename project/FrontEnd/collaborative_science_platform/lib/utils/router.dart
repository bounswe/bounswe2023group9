// GoRouter configuration
import 'dart:math';

import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/notifications_page/notifications_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/workspaces_page.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  navigatorKey: ScreenNavigation.navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: LoginPage.routeName.substring(1),
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) {
        if (context.read<Auth>().isSignedIn) {
          return HomePage.routeName;
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      name: SignUpPage.routeName.substring(1),
      path: SignUpPage.routeName,
      builder: (context, state) => const SignUpPage(),
      redirect: (context, state) {
        if (context.read<Auth>().isSignedIn) {
          return HomePage.routeName;
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      name: WorkspacesPage.routeName.substring(1),
      path: WorkspacesPage.routeName,
      builder: (context, state) => const WorkspacesPage(),
    ),
    GoRoute(
      name: GraphPage.routeName.substring(1),
      path: "${GraphPage.routeName}/:nodeId",
      builder: (context, state) {
        final int nodeId = int.tryParse(state.pathParameters['nodeId'] ?? '') ?? 0;
        return GraphPage(nodeId: nodeId);
      },
    ),
    GoRoute(
      name: "/graph",
      path: GraphPage.routeName,
      redirect: (context, state) {
        final int nodeId = Random().nextInt(100);
        return "${GraphPage.routeName}/$nodeId";
      },
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
