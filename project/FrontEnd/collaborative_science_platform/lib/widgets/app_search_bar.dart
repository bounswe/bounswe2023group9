import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

enum SearchType { theorem, author, by, both }

class AppSearchBar extends StatefulWidget {
  final Function(SearchType) onSearch;
  final FocusNode focusNode;
  final TextEditingController controller;

  const AppSearchBar(
      {required this.onSearch,
      required this.controller,
      required this.focusNode,
      super.key});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  SearchType searchType = SearchType.theorem;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                widget.onSearch(searchType);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                width: 38,
                height: 38,
                child: Icon(
                  Icons.search,
                  color: Colors.indigo[500],
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]!),
                isCollapsed: true,
              ),
            ),
          ),
          const SizedBox(width: 4.0),
          PopupMenuButton<SearchType>(
            position: PopupMenuPosition.under,
            color: Colors.grey.shade200,
            onSelected: (SearchType newSearchType) {
              setState(() {
                searchType = newSearchType;
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
          SizedBox(width: (Responsive.isMobile(context)) ? 10.0 : 20.0),
        ],
      ),
    );
  }
}
