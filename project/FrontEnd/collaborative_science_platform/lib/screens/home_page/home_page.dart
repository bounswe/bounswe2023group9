import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final searchBarController = TextEditingController();
  final searchBarFocusNode = FocusNode();
  bool searchBarActive = false;

  @override
  void dispose() {
    searchBarController.dispose();
    searchBarFocusNode.dispose();
    super.dispose();
  }

  void search() {}

  @override
  Widget build(BuildContext context) {
    return MobileHomePage(
      searchBarFocusNode: searchBarFocusNode,
      searchBarController: searchBarController,
      onSearch: search,
    );
  }
}

class DesktopMobilePage extends StatelessWidget {
  const DesktopMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({
    super.key,
    required this.searchBarFocusNode,
    required this.searchBarController,
    required this.onSearch,
  });

  final FocusNode searchBarFocusNode;
  final TextEditingController searchBarController;
  final Function() onSearch;

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 16 pixels padding in 4 directions
        child: Center(
          child: SizedBox(
            width: Responsive.getGenericPageWidth(context),
            child: SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSearchBar(
                    focusNode: searchBarFocusNode,
                    controller: searchBarController,
                    onSearch: onSearch,
                  ),
                  const SizedBox(height: 10.0),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Prevents a conflict with SingleChildScrollView
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return HomePageNode(
                        nodeTitle: "Lorem Ipsum ${index + 1}",
                        nodeContent:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis knostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        onTap: () {/* Navigate to the Screen of the Node */},
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
