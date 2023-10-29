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
    final ScreenNavigation screenNavigation =
        Provider.of<ScreenNavigation>(context);
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
          value: ScreenTab.workspace,
          isSelected: screenNavigation.selectedTab == ScreenTab.workspace,
          text: "Workspace",
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
            text: "Profile Options",
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
        onTap: () => Provider.of<ScreenNavigation>(context, listen: false)
            .setSelectedTab(widget.value),
        child: Container(
          color: Colors.transparent,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      children: [
                        Icon(
                          widget.icon,
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
            )
          ]),
        ),
      ),
    );
  }
}
