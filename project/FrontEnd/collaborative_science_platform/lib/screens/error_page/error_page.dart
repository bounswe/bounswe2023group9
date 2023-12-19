import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  static const routeName = '/page_not_found/';
  const ErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            "404",
            style: TextStyles.title4.copyWith(fontSize: 120),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
          child: const Text(
            "This page doesn't exist.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryDarkColor,
            ),
          ),
        ),
        const SizedBox(height: 8.0), // Add space between texts
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              context.go(HomePage.routeName);
            },
            child: const Text(
              "Return to main page",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 67, 85, 186),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
