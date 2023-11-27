import 'package:flutter/material.dart';

/// A widget for creating a page with a customizable app bar and content.
///
/// This widget allows you to create a page with an app bar and content area.
/// The app bar can be customized using the [appBar] parameter, and the content
/// can be set using the [child] parameter. You can also specify the background
/// color of the content area using the [pageColor] parameter and control
/// whether the content is scrollable with the [isScrollable] parameter.
class PageWithAppBar extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  final Color pageColor;
  final bool isScrollable;
  final Navigator? navigator;
  final FloatingActionButton? floatingActionButton;

  /// Creates a [PageWithAppBar] widget.
  ///
  /// The [child] parameter represents the content to be displayed below the app bar.
  /// The [appBar] parameter is a widget that serves as the app bar.
  /// The [pageColor] parameter specifies the background color of the content area (default: Colors.white).
  /// The [isScrollable] parameter indicates whether the content is scrollable (default: true).
  const PageWithAppBar(
      {required this.child,
      required this.appBar,
      this.pageColor = Colors.white,
      this.isScrollable = true,
      this.navigator,
      this.floatingActionButton,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SelectionArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          floatingActionButton: floatingActionButton,
          body: SingleChildScrollView(
            physics:
                isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                appBar,
                Divider(
                  height: 0,
                  thickness: 2,
                  color: Colors.grey[300],
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
