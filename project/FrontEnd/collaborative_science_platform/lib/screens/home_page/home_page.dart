import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_user_card.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchBarController = TextEditingController();
  final searchBarFocusNode = FocusNode();
  bool searchBarActive = false;

  @override
  void dispose() {
    searchBarController.dispose();
    searchBarFocusNode.dispose();
    super.dispose();
  }

  void search(SearchType searchType) { }

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
  final FocusNode searchBarFocusNode;
  final TextEditingController searchBarController;
  final Function(SearchType) onSearch;

  const MobileHomePage({
    super.key,
    required this.searchBarFocusNode,
    required this.searchBarController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      child: SizedBox(
        width: Responsive.getGenericPageWidth(context),
        child: SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 16.0, 8.0, 0.0),
                child: AppSearchBar(
                  focusNode: searchBarFocusNode,
                  controller: searchBarController,
                  onSearch: onSearch,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Prevents a conflict with SingleChildScrollView
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return HomePageUserCard(
                      profileData: ProfileData.getLoremIpsum(index+1),
                      onTap: () { /* Navigate to the Profile Page of the User */ },
                      color: AppColors.primaryLightColor,
                      profilePagePath: (index % 2 == 0) ? "assets/images/gumball.jpg" : null,
                    );

                    /*
                    return HomePageNodeCard(
                      smallNode: SmallNode.getLoremIpsum(index+1),
                      onTap: () { /* Navigate to the Screen of the Node */ },
                    );
                     */
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
