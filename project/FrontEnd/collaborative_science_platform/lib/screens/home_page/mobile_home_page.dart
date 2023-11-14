import 'package:collaborative_science_platform/helpers/search_helper.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/node_cards.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/user_cards.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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