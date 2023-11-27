import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/services/screen_navigation.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenNavigation screenNavigation = Provider.of<ScreenNavigation>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NavigationBarItem(
          icon: Icons.dashboard,
          value: ScreenTab.home,
          text: "Home",
          isSelected: screenNavigation.selectedTab == ScreenTab.home,
        ),
        NavigationBarItem(
          icon: Icons.graphic_eq,
          value: ScreenTab.graph,
          text: "Graph",
          isSelected: screenNavigation.selectedTab == ScreenTab.graph,
        ),
        NavigationBarItem(
          icon: Icons.workspaces,
          value: ScreenTab.workspaces,
          isSelected: screenNavigation.selectedTab == ScreenTab.workspaces,
          text: "Workspaces",
        ),
        if (Responsive.isMobile(context))
          NavigationBarItem(
            icon: Icons.notifications,
            value: ScreenTab.notifications,
            isSelected: screenNavigation.selectedTab == ScreenTab.notifications,
            text: "Notifications",
          ),
        if (Responsive.isMobile(context))
          NavigationBarItem(
            icon: Icons.person,
            value: ScreenTab.profile,
            isSelected: screenNavigation.selectedTab == ScreenTab.profile,
            text: "Profile",
          ),
      ],
    );
  }
}

class NavigationBarItem extends StatefulWidget {
  final ScreenTab value;
  final String text;
  final IconData icon;
  final bool isSelected;
  const NavigationBarItem({
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.text,
    super.key,
  });

  @override
  State<NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<NavigationBarItem> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => isHovering = true),
      onExit: (event) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () {
          ScreenTab selected = widget.value;
          if (selected == ScreenTab.profile) {
            String userEmail = Provider.of<Auth>(context, listen: false).user?.email ?? "";
            Provider.of<ScreenNavigation>(context, listen: false)
                .setSelectedTab(selected, context, email: Uri.decodeComponent(userEmail));
            return;
          } else {
            Provider.of<ScreenNavigation>(context, listen: false).setSelectedTab(selected, context);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          color: isHovering ? Colors.grey[300] : Colors.transparent,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: (Responsive.isMobile(context))
                      ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
                      : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              widget.icon,
                              size: isHovering ? 32 : 28.0,
                              color: widget.isSelected
                                  ? Colors.indigo[600]
                                  : isHovering
                                      ? Colors.indigo[200]
                                      : Colors.grey[700],
                            ),
                            if (!Responsive.isMobile(context))
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  widget.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: widget.isSelected
                                        ? FontWeight.w700
                                        : isHovering
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                    color: widget.isSelected
                                        ? Colors.indigo[600]
                                        : isHovering
                                            ? Colors.indigo[200]
                                            : Colors.grey[700],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      //const SizedBox(height: 12),
                      /*   Container(
                    color: widget.isSelected ? Colors.indigo[600] : Colors.transparent,
                    height: 4,
                    width: 150,
                  ) */
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  color: widget.isSelected ? Colors.indigo[600] : Colors.transparent,
                  height: 5,
                  width: MediaQuery.of(context).size.width / 5,
                ),
              ]),
        ),
      ),
    );
  }
}
