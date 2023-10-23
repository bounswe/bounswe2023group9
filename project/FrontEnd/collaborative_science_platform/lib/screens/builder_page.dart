import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/notifications_page.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_options.dart';
import 'package:collaborative_science_platform/screens/graph_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuilderPage extends StatelessWidget {
  const BuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      navigator: Navigator(
        key: Provider.of<ScreenNavigation>(context).navigatorKey,
        initialRoute: HomePage.routeName,
        onGenerateRoute: _onGenerateRoute,
      ),
      child: const SizedBox(),
    );
  }

  // Widget getCurrentPage(BuildContext context) {
  //   final ScreenNavigation screenNavigation = Provider.of<ScreenNavigation>(context);
  //   switch (screenNavigation.selectedTab) {
  //     case ScreenTab.home:
  //       html.window.history.pushState({}, '', HomePage.routeName);
  //       return const HomePage();
  //     case ScreenTab.graph:
  //       html.window.history.pushState({}, '', ProfilePage.routeName);
  //       return const ProfilePage();
  //     case ScreenTab.workspace:
  //       html.window.history.pushState({}, '', WorkspacesPage.routeName);
  //       return const WorkspacesPage();
  //   }
  // }
}

Route _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(builder: (context) => const HomePage(), settings: settings);
    case GraphPage.routeName:
      return MaterialPageRoute(builder: (context) => const GraphPage(), settings: settings);
    case WorkspacesPage.routeName:
      return MaterialPageRoute(builder: (context) => const WorkspacesPage(), settings: settings);
    case NotificationPage.routeName:
      return MaterialPageRoute(builder: (context) => const NotificationPage(), settings: settings);
    case ProfileOptions.routeName:
      return MaterialPageRoute(builder: (context) => const ProfileOptions(), settings: settings);
    default:
      return MaterialPageRoute(builder: (context) => const HomePage(), settings: settings);
  }
}
