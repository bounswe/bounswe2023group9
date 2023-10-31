import 'package:collaborative_science_platform/helpers/search_helper.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_user_card.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/responsive/responsive.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchBarFocusNode = FocusNode();
  bool searchBarActive = false;
  bool error = false;
  bool isLoading = false;
  bool firstSearch = false;
  String errorMessage = "";

  @override
  void dispose() {
    searchBarFocusNode.dispose();
    super.dispose();
  }

  void search(String text) async {
    SearchType searchType = SearchHelper.searchType;
    if (text.isEmpty) return;
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
      setState(() {
        isLoading = true;
        firstSearch = true;
      });
      if (searchType == SearchType.author) {
        await userProvider.search(searchType, text);
      } else if (searchType == SearchType.both) {
        await userProvider.search(searchType, text);
        await nodeProvider.search(searchType, text);
      } else {
        await nodeProvider.search(searchType, text);
      }
    } catch (e) {
      print(e);
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileHomePage(
      searchBarFocusNode: searchBarFocusNode,
      onSearch: search,
      isLoading: isLoading,
      firstSearch: firstSearch,
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
  final Function onSearch;
  final bool isLoading;
  final bool firstSearch;

  const MobileHomePage({
    super.key,
    required this.searchBarFocusNode,
    required this.onSearch,
    required this.isLoading,
    required this.firstSearch,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nodeProvider = Provider.of<NodeProvider>(context);
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      child: SingleChildScrollView(
        primary: false,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: Responsive.getGenericPageWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 16.0, 8.0, 0.0),
                child: AppSearchBar(
                  focusNode: searchBarFocusNode,
                  onSearch: onSearch,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (SearchHelper.searchType == SearchType.author)
                          ? UserCards(
                              userList: userProvider.searchUserResult,
                              firstSearch: firstSearch,
                            )
                          : NodeCards(
                              nodeList: nodeProvider.searchNodeResult,
                              firstSearch: firstSearch,
                            )),
            ],
          ),
        ),
      ),
    );
  }
}

class NodeCards extends StatelessWidget {
  final List<SmallNode> nodeList;
  final bool firstSearch;

  const NodeCards({
    super.key,
    required this.nodeList,
    required this.firstSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: firstSearch && nodeList.isEmpty
          ? const Center(
              child: Text("No results found."),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: nodeList.length,
              itemBuilder: (context, index) {
                return HomePageNodeCard(
                  smallNode: nodeList[index],
                  onTap: () {
                    Navigator.pushNamed(context, NodeDetailsPage.routeName,
                        arguments: nodeList[index].nodeId);
                  },
                );
              },
            ),
    );
  }
}

class UserCards extends StatelessWidget {
  final List<ProfileData> userList;
  final bool firstSearch;

  const UserCards({
    super.key,
    required this.userList,
    required this.firstSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: firstSearch && userList.isEmpty
          ? const Center(
              child: Text("No results found."),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return HomePageUserCard(
                  profileData: userList[index],
                  onTap: () {/* Navigate to the Profile Page of the User */},
                  color: AppColors.primaryLightColor,
                  profilePagePath: "assets/images/gumball.jpg",
                );
              },
            ),
    );
  }
}
