import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/notifications_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page.dart';
import 'package:flutter/material.dart';

enum ScreenTab { home, graph, workspace, notifications, profile, pleaseLogin, none }

class ScreenNavigation extends ChangeNotifier {
  ScreenTab _selectedTab = ScreenTab.home;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ScreenTab get selectedTab => _selectedTab;

  void setSelectedTab(ScreenTab tab) {
    _selectedTab = tab;
    switch (tab) {
      case ScreenTab.home:
        navigatorKey.currentState?.pushNamed(HomePage.routeName);
        break;
      case ScreenTab.graph:
        navigatorKey.currentState?.pushNamed(GraphPage.routeName);
        break;
      case ScreenTab.workspace:
        navigatorKey.currentState?.pushNamed(WorkspacesPage.routeName);
        break;
      case ScreenTab.notifications:
        navigatorKey.currentState?.pushNamed(NotificationPage.routeName);
        break;
      case ScreenTab.profile:
        navigatorKey.currentState?.pushNamed(ProfilePage.routeName, arguments: "");
        break;
      case ScreenTab.pleaseLogin:
        navigatorKey.currentState?.pushNamed(PleaseLoginPage2.routeName);
        break;
      case ScreenTab.none:
        break;
    }
    notifyListeners();
  }
}
