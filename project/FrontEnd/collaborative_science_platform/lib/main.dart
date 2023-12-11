import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/question_provider.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/providers/workspace_provider.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
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
        ChangeNotifierProvider<WorkspaceProvider>(create: (context) => WorkspaceProvider()),
        ChangeNotifierProvider<QuestionAnswerProvider>(
            create: (context) => QuestionAnswerProvider()),
      ],
      child: Portal(
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          title: Constants.appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 85, 234, 145)),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
