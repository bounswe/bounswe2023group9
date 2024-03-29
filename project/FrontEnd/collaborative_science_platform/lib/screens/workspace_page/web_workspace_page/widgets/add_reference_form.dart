import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReferenceForm extends StatefulWidget {
  final Function onAdd;
  const AddReferenceForm({super.key, required this.onAdd});

  @override
  State<AddReferenceForm> createState() => _AddReferenceFormState();
}

class _AddReferenceFormState extends State<AddReferenceForm> {
  final searchBarFocusNode = FocusNode();
  bool isLoading = false;
  bool firstSearch = false;

  bool error = false;
  String errorMessage = "";

  @override
  void dispose() {
    searchBarFocusNode.dispose();
    super.dispose();
  }

  void search(String text) async {
    SearchType searchType = SearchType.theorem;
    if (text.isEmpty) return;
    try {
      final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
      setState(() {
        isLoading = true;
        firstSearch = true;
      });
      await nodeProvider.search(searchType, text);
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
    final nodeProvider = Provider.of<NodeProvider>(context);
    return SizedBox(
      height: 600,
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
                hintText: "Search Theorem",
                focusNode: searchBarFocusNode,
                onSearch: search,
                hideSearchType: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 500,
                      width: 500,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 50.0),
                          itemCount: nodeProvider.searchNodeResult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: CardContainer(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nodeProvider.searchNodeResult[index].nodeTitle,
                                            style: TextStyles.bodyBold,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            nodeProvider.searchNodeResult[index].contributors
                                                .map((e) => "${e.firstName} ${e.lastName}")
                                                .join(", "),
                                            style: TextStyles.bodyGrey,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            nodeProvider
                                                .searchNodeResult[index].publishDateFormatted,
                                            style: TextStyles.bodyGrey,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        widget.onAdd(nodeProvider.searchNodeResult[index].id);
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
