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
import 'package:collaborative_science_platform/screens/workspace_page/workspaces_page.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/workspace_page/create_workspace_page/mobile_create_workspace_page.dart';

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
        builder: (context, state) {
          return const WorkspacesPage();
        },
        redirect: (context, state) {
          if (!context.read<Auth>().isSignedIn) {
            return '${PleaseLoginPage.routeName}${WorkspacesPage.routeName}';
          } else {
            return null;
          }
        },
        routes: [
          GoRoute(
            name: "workspace",
            path: ":workspaceId",
            builder: (context, state) {
              final int workspaceId = int.tryParse(state.pathParameters['workspaceId'] ?? '') ?? 0;
              return WorkspacesPage(workspaceId: workspaceId);
            },
          ),
        ]),
    GoRoute(
      name: MobileCreateWorkspacePage.routeName.substring(1),
      path: MobileCreateWorkspacePage.routeName,
      builder: (context, state) => const MobileCreateWorkspacePage(),
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
      redirect: (context, state) {
        if (!context.read<Auth>().isSignedIn) {
          return '${PleaseLoginPage.routeName}${NotificationPage.routeName}';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      name: AccountSettingsPage.routeName.substring(1),
      path: AccountSettingsPage.routeName,
      builder: (context, state) => const AccountSettingsPage(),
    ),
    GoRoute(
      name: "/please-login",
      path: PleaseLoginPage.routeName,
      builder: (context, state) => const PleaseLoginPage(),
    ),
    GoRoute(
      name: PleaseLoginPage.routeName.substring(1),
      path: "${PleaseLoginPage.routeName}/:pageType",
      builder: (context, state) {
        final String pageType = state.pathParameters['pageType'] ?? '';
        return PleaseLoginPage(pageType: pageType);
      },
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
      name: "/profile",
      path: ProfilePage.routeName,
      builder: (context, state) {
        if (!context.read<Auth>().isSignedIn) {
          return PleaseLoginPage(pageType: ProfilePage.routeName.substring(1));
        }
        return ProfilePage(email: "");
      },
    ),
    GoRoute(
      name: ProfilePage.routeName.substring(1),
      path: "${ProfilePage.routeName}/:email",
      builder: (context, state) {
        final String encodedEmail = state.pathParameters['email'] ?? '';
        final String email = Uri.decodeComponent(encodedEmail);
        print(context.read<Auth>().isSignedIn);
        return ProfilePage(email: email);
      },
      redirect: (context, state) {
        print(context.read<Auth>().isSignedIn);
        if (!context.read<Auth>().isSignedIn &&
            (state.pathParameters['email'] == null || state.pathParameters['email'] == '')) {
          return '${PleaseLoginPage.routeName}${ProfilePage.routeName}';
        } else {
          return null;
        }
      },
    ),
  ],
);
