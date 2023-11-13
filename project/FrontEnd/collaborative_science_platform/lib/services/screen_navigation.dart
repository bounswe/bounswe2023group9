import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/notifications_page/notifications_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/workspaces_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ScreenTab { home, graph, workspace, notifications, profile, pleaseLogin, none }

class ScreenNavigation extends ChangeNotifier {
  ScreenTab _selectedTab = ScreenTab.home;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ScreenTab get selectedTab => _selectedTab;

  void setSelectedTab(ScreenTab tab, BuildContext context, {String? email}) {
    _selectedTab = tab;
    switch (tab) {
      case ScreenTab.home:
        context.go(HomePage.routeName);
        break;
      case ScreenTab.graph:
        context.push(GraphPage.routeName);
        break;
      case ScreenTab.workspace:
        context.go(WorkspacesPage.routeName);
        break;
      case ScreenTab.notifications:
        context.go(NotificationPage.routeName);
        break;
      case ScreenTab.profile:
        context.go(ProfilePage.routeName);
        break;
      case ScreenTab.pleaseLogin:
        context.go(PleaseLoginPage2.routeName);
        break;
      case ScreenTab.none:
        break;
    }
    notifyListeners();
  }
}
