import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/login_page.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_options.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:collaborative_science_platform/widgets/app_bar_widgets/app_bar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return auth.isSignedIn ? AuthenticatedProfileMenu() : UnAuthenticatedProfileMenu();
  }
}

class AuthenticatedProfileMenu extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<dynamic>> _popupMenu = GlobalKey<PopupMenuButtonState>();
  AuthenticatedProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return PopupMenuButton<String>(
      key: _popupMenu,
      position: PopupMenuPosition.under,
      color: Colors.grey[200],
      onSelected: (String result) async {
        switch (result) {
          case 'profile':
            Provider.of<ScreenNavigation>(context, listen: false).setSelectedTab(ScreenTab.profileOptions);
            Navigator.pushNamed(context, ProfileOptions.routeName);
            break;
          case 'logout':
            await auth.logout();
            break;
          default:
        }
      },
      child: AppBarButton(
        icon: CupertinoIcons.chevron_down,
        text: Provider.of<Auth>(context).user!.firstName,
        onPressed: () => _popupMenu.currentState!.showButtonMenu(),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text("Profile"),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text("Logout"),
        )
      ],
    );
  }
}

class UnAuthenticatedProfileMenu extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<dynamic>> _popupMenu = GlobalKey<PopupMenuButtonState>();
  UnAuthenticatedProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: _popupMenu,
      position: PopupMenuPosition.under,
      color: Colors.grey[200],
      onSelected: (String result) async {
        switch (result) {
          case 'signin':
            Navigator.pushNamed(context, LoginPage.routeName);
            break;
          case 'signup':
            Navigator.pushNamed(context, SignUpPage.routeName);
            break;
          default:
        }
      },
      child: AppBarButton(
        icon: CupertinoIcons.chevron_down,
        text: "Sign In",
        onPressed: () => _popupMenu.currentState!.showButtonMenu(),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'signin',
          child: Text("Sign In"),
        ),
        const PopupMenuItem<String>(
          value: 'signup',
          child: Text("Sign Up"),
        )
      ],
    );
  }
}
