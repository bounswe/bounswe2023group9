import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/please_login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Provider.of<Auth>(context, listen: false).logout();
          Navigator.pushNamed(context, PleaseLoginPage2.routeName);
        },
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}
