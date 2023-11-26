import 'package:collaborative_science_platform/exceptions/search_exceptions.dart';
import 'package:collaborative_science_platform/helpers/search_helper.dart';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
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

  bool _firstTime = true;
  String errorMessage = "";

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      randomNodes();
      _firstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchBarFocusNode.dispose();
    super.dispose();
  }

  void randomNodes() async {
    try {
      final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await nodeProvider.search(SearchType.both, "", random: true);
    } on WrongSearchTypeError {
      setState(() {
        error = true;
        errorMessage = WrongSearchTypeError().message;
      });
    } on SearchError {
      setState(() {
        error = true;
        errorMessage = SearchError().message;
      });
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

  void search(String text) async {
    if (text.isEmpty) return;
    if (text.length < 4) return;
    SearchType searchType = SearchHelper.searchType;
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
    } on WrongSearchTypeError {
      setState(() {
        error = true;
        errorMessage = WrongSearchTypeError().message;
      });
    } on SearchError {
      setState(() {
        error = true;
        errorMessage = SearchError().message;
      });
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

  void semanticSearch(SemanticTag tag) async {
    SearchType searchType = SearchHelper.searchType;
    try {
      final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await nodeProvider.search(searchType, tag.id, semantic: true);
    } on WrongSearchTypeError {
      setState(() {
        error = true;
        errorMessage = WrongSearchTypeError().message;
      });
    } on SearchError {
      setState(() {
        error = true;
        errorMessage = SearchError().message;
      });
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
      onSemanticSearch: semanticSearch,
      isLoading: isLoading,
      error: error,
      errorMessage: errorMessage,
    );
  }
}
