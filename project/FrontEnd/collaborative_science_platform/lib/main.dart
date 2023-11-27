import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:collaborative_science_platform/utils/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() {
  configureApp();
  runApp(const MyApp());
}

void configureApp() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
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
      child: Portal(
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          title: Constants.appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 85, 234, 145)),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
