import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/providers/wiki_data_provider.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';

class SemanticSearchBar extends StatefulWidget {
  final Function addSemanticTag;

  const SemanticSearchBar({
    super.key,
    required this.addSemanticTag,
  });

  @override
  State<SemanticSearchBar> createState() => _SemanticSearchBarState();
}

class _SemanticSearchBarState extends State<SemanticSearchBar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController labelController = TextEditingController();
  final FocusNode labelFocusNode = FocusNode();
  final int maxLength = 5;

  List<SemanticTag> tags = [];
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";
  int selectedIndex = -1;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    labelController.dispose();
    labelFocusNode.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    try {
      final WikiDataProvider wikiDataProvider = Provider.of<WikiDataProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await wikiDataProvider.wikiDataSearch(query, maxLength);
      setState(() {
        tags = wikiDataProvider.tags;
      });
    } catch (e) {
      error = true;
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget searchResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (tags.isNotEmpty) const Text(
          "Search Results",
          style: TextStyles.bodySecondary,
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tags.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: AppColors.primaryLightColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tags[index].label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      tags[index].description,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (index == selectedIndex) Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: labelController,
                                  focusNode: labelFocusNode,
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                    hintText: "Tag Name",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey[600]!),
                                    isCollapsed: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (labelController.text.isNotEmpty) {
                              await widget.addSemanticTag(tags[index].wid, labelController.text);
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (index == selectedIndex) {
                              selectedIndex = -1;
                              labelController.text = "";
                            } else {
                              selectedIndex = index;
                            }
                          });
                        },
                        icon: Icon(
                          (index == selectedIndex) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      if (searchController.text.isNotEmpty) {
                        await search(searchController.text);
                      }
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
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: searchController,
                    focusNode: searchFocusNode,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search Tag",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]!),
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        (isLoading) ? const Center(child: CircularProgressIndicator()) :
        (error) ? Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ) : searchResults()
      ],
    );
  }
}
