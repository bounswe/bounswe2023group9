import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspace_page/workspaces_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/workspace_page/create_workspace_page/mobile_create_workspace_page.dart';

enum ScreenTab {
  home,
  graph,
  workspaces,
  workspace,
  createWorkspace,
  //notifications,
  profile,
  pleaseLogin,
  none
}

class ScreenNavigation extends ChangeNotifier {
  ScreenTab _selectedTab = ScreenTab.home;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ScreenTab get selectedTab => _selectedTab;

  void changeSelectedTab(ScreenTab tab) {
    _selectedTab = tab;
  }

  void setSelectedTab(ScreenTab tab, BuildContext context, {String? email}) {
    _selectedTab = tab;
    switch (tab) {
      case ScreenTab.home:
        context.go(HomePage.routeName);
        break;
      case ScreenTab.graph:
        context.go(GraphPage.routeName);
        break;
      case ScreenTab.workspaces: // Goes to the page where workspace names are listed
        context.go(WorkspacesPage.routeName);
        break;
      case ScreenTab.workspace: // Goes to the page where details of a workspace are listed
        context.go(WorkspacesPage.routeName);
        break;
      case ScreenTab.createWorkspace: // Goes to the page where workspaces are created
        context.go(MobileCreateWorkspacePage.routeName);
        break;
      // case ScreenTab.notifications:
      //   context.go(NotificationPage.routeName);
      //   break;
      case ScreenTab.profile:
        if (email == "") {
          context.go(ProfilePage.routeName);
        } else {
          context.go('${ProfilePage.routeName}/$email');
        }
        break;
      case ScreenTab.pleaseLogin:
        context.go(PleaseLoginPage.routeName);
        break;
      case ScreenTab.none:
        break;
    }
    notifyListeners();
  }
}
