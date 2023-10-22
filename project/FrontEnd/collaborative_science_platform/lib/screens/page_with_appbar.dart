import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
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

  /// Creates a [PageWithAppBar] widget.
  ///
  /// The [child] parameter represents the content to be displayed below the app bar.
  /// The [appBar] parameter is a widget that serves as the app bar.
  /// The [pageColor] parameter specifies the background color of the content area (default: Colors.white).
  /// The [isScrollable] parameter indicates whether the content is scrollable (default: true).
  const PageWithAppBar(
      {required this.child, required this.appBar, this.pageColor = Colors.white, this.isScrollable = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 5,
              floating: true,
              snap: true,
              surfaceTintColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Divider(
                  height: 0,
                  thickness: 2,
                  color: Colors.grey[300],
                ),
              ),
              collapsedHeight: Responsive.isMobile(context) ? 60 : 70,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 12 : 16, horizontal: 20),
                  child: appBar,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                color: pageColor,
                child: child,
              ),
            ),
          ],
        ));
  }
}
