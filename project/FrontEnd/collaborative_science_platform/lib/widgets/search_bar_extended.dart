import 'package:collaborative_science_platform/helpers/search_helper.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarExtended extends StatefulWidget {
  final Function semanticSearch;
  final Function exactSearch;
  const SearchBarExtended({super.key, required this.semanticSearch, required this.exactSearch});

  @override
  State<SearchBarExtended> createState() => _SearchBarExtendedState();
}

class _SearchBarExtendedState extends State<SearchBarExtended> {
  SearchType searchType = SearchHelper.searchType;
  SearchOption searchOption = SearchHelper.searchOption;

  Widget searchTypeSelector() {
    if (Responsive.isMobile(context)) {
      return Icon(
        (searchType == SearchType.theorem)
            ? Icons.description_rounded
            : (searchType == SearchType.author)
                ? Icons.person
                : (searchType == SearchType.by)
                    ? Icons.person_2_outlined
                    : Icons.list_rounded,
        color: Colors.indigo.shade500,
      );
    } else {
      return Row(
        children: [
          Icon(
            (searchType == SearchType.theorem)
                ? Icons.description_rounded
                : (searchType == SearchType.author)
                    ? Icons.person
                    : (searchType == SearchType.by)
                        ? Icons.person_2_outlined
                        : Icons.list_rounded,
            color: Colors.indigo.shade500,
          ),
          const SizedBox(width: 4.0),
          Text(
            (searchType == SearchType.theorem)
                ? "Theorem"
                : (searchType == SearchType.author)
                    ? "Author"
                    : (searchType == SearchType.by)
                        ? "By"
                        : "Both",
            style: TextStyle(
              color: Colors.indigo.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }

  Widget searchTypeSelector2() {
    if (Responsive.isMobile(context)) {
      return Icon(
        (searchOption == SearchOption.semantic) ? Icons.abc : CupertinoIcons.smallcircle_circle,
        color: Colors.indigo.shade500,
      );
    } else {
      return Row(
        children: [
          Icon(
            (searchOption == SearchOption.semantic) ? Icons.abc : CupertinoIcons.smallcircle_circle,
            color: Colors.indigo.shade500,
          ),
          const SizedBox(width: 4.0),
          Text(
            (searchOption == SearchOption.semantic) ? "Semantic" : "Exact",
            style: TextStyle(
              color: Colors.indigo.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }

  Future<List<String>> _getSuggestions(String query) async {
    if (searchOption == SearchOption.exact) return [];
    if (query.length < 3) return [];
    return Future.delayed(const Duration(milliseconds: 500), () {
      return [
        "Theorem 1",
        "Theorem 2",
        "Theorem 3",
        "Theorem 4",
        "Theorem 5",
        "Theorem 6",
        "Theorem 7",
        "Theorem 8",
        "Theorem 9",
        "Theorem 10",
      ];
    });
  }

  Widget _suggestionLoaderBuilder() {
    if (searchOption == SearchOption.exact) return const SizedBox();
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var actions2 = [
      PopupMenuButton<SearchOption>(
        position: PopupMenuPosition.under,
        color: Colors.grey.shade200,
        onSelected: (SearchOption newSearchType) {
          setState(() {
            searchOption = newSearchType;
            SearchHelper.searchOption = newSearchType;
          });
        },
        initialValue: searchOption,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SearchOption>>[
          const PopupMenuItem<SearchOption>(
            value: SearchOption.semantic,
            child: Row(
              children: [
                Icon(Icons.abc),
                SizedBox(width: 8.0),
                Text("Semantic"),
              ],
            ),
          ),
          const PopupMenuItem<SearchOption>(
            value: SearchOption.exact,
            child: Row(
              children: [
                Icon(CupertinoIcons.smallcircle_circle),
                SizedBox(width: 4.0),
                Text("Exact"),
              ],
            ),
          ),
        ],
        child: searchTypeSelector2(),
      ),
      const SizedBox(width: 4.0),
      PopupMenuButton<SearchType>(
        position: PopupMenuPosition.under,
        color: Colors.grey.shade200,
        onSelected: (SearchType newSearchType) {
          setState(() {
            searchType = newSearchType;
            SearchHelper.searchType = newSearchType;
          });
        },
        initialValue: searchType,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SearchType>>[
          const PopupMenuItem<SearchType>(
            value: SearchType.theorem,
            child: Row(
              children: [
                Icon(Icons.description_rounded),
                SizedBox(width: 4.0),
                Text("Theorem"),
              ],
            ),
          ),
          const PopupMenuItem<SearchType>(
            value: SearchType.author,
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 4.0),
                Text("Author"),
              ],
            ),
          ),
          const PopupMenuItem<SearchType>(
            value: SearchType.by,
            child: Row(
              children: [
                Icon(Icons.person_2_outlined),
                SizedBox(width: 4.0),
                Text("By"),
              ],
            ),
          ),
          const PopupMenuItem<SearchType>(
            value: SearchType.both,
            child: Row(
              children: [
                Icon(Icons.list_rounded),
                SizedBox(width: 4.0),
                Text("Both"),
              ],
            ),
          )
        ],
        child: searchTypeSelector(),
      ),
    ];
    return SizedBox(
      height: 55,
      child: EasySearchBar(
        title: const Text('Select a type to start searching'),
        onSearch: (value) {
          if (searchOption == SearchOption.semantic) {
            widget.semanticSearch(value);
          } else {
            widget.exactSearch(value);
          }
        },
        asyncSuggestions:
            (searchOption == SearchOption.exact) ? null : (value) => _getSuggestions(value),
        suggestionLoaderBuilder: () => _suggestionLoaderBuilder(),
        onSuggestionTap: (data) => widget.semanticSearch(data),
        searchTextStyle: const TextStyle(color: Colors.grey),
        elevation: 2,
        searchBackIconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.grey[600]!),
        actions: actions2,
      ),
    );
  }
}
