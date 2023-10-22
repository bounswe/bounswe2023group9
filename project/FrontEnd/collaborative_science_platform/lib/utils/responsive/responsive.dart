import 'package:flutter/material.dart';

const double tabletBreakpoint = 768;
const double desktopBreakpoint = 1200;

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint && MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return desktop;
    } else if (screenWidth >= tabletBreakpoint) {
      if (tablet == null) {
        return desktop;
      }
      return tablet!;
    } else {
      return mobile;
    }
  }
}
