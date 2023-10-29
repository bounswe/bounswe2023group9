import 'package:collaborative_science_platform/screens/profile_page/account_settings.dart';
import 'package:flutter/material.dart';

class DesktopEditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Show Popup with EditProfileForm content
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: SizedBox(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Edit Profile',
                              style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    content: EditProfileForm(),
                  ));
        },
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10.0),
              Text('Edit Profile',
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
