import 'package:collaborative_science_platform/helpers/search_helper.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/screens/home_page/mobile_home_page.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
