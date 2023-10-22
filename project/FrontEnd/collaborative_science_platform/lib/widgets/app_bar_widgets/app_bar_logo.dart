import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, HomePage.routeName),
        child: Container(
          color: Colors.transparent,
          child: SvgPicture.asset(
            'assets/images/logo_small.svg',
            height: 80,
          ),
        ),
      ),
    );
  }
}
