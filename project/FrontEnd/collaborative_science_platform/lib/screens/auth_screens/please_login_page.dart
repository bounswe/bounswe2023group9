import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/widgets/please_login_signup.dart';
import 'package:collaborative_science_platform/screens/auth_screens/widgets/please_login_prompts.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PleaseLoginPage extends StatelessWidget {
  static const routeName = '/please-login';
  final String? pageType;
  const PleaseLoginPage({
    super.key,
    this.pageType,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      child: SizedBox(
        width: Responsive.getGenericPageWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: Divider(height: 40.0),
              ),
              if (pageType == "notifications") NotificationExplanation(),
              if (pageType == "workspaces") WorkspaceExplanation(),
              if (pageType == "profile") ProfileExplanation(),
              if (pageType != null)
                const Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Divider(height: 40.0),
                ),
              if (!auth.isSignedIn)
              PleaseLoginSignup(),
              const Padding(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: Divider(height: 40.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
