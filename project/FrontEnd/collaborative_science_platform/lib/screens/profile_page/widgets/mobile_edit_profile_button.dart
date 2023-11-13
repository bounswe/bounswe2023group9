import 'package:collaborative_science_platform/screens/profile_page/account_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileEditProfileButton extends StatelessWidget {
  const MobileEditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            context.go(AccountSettingsPage.routeName);
          },
          child: Container(
            height: 40.0,
            // width: MediaQuery.of(context).size.width - 80,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: Colors.white),
                SizedBox(width: 10.0),
                Text('Edit Profile',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
