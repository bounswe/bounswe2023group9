import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class PageWithAppBar extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  final Color pageColor;
  final bool isScrollable;
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
