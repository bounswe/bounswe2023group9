import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendCollaborationRequestForm extends StatefulWidget {
  final Function sendCollaborationRequest;
  const SendCollaborationRequestForm({
    super.key,
    required this.sendCollaborationRequest,
  });

  @override
  State<SendCollaborationRequestForm> createState() => _SendCollaborationRequestFormState();
}

class _SendCollaborationRequestFormState extends State<SendCollaborationRequestForm> {
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
    SearchType searchType = SearchType.author;
    if (text.isEmpty) return;
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        isLoading = true;
        firstSearch = true;
      });
      await userProvider.search(searchType, text);
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
    final userProvider = Provider.of<UserProvider>(context);
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
                hintText: "Search User",
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
                          itemCount: userProvider.searchUserResult.length,
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${userProvider.searchUserResult[index].name} ${userProvider.searchUserResult[index].surname}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.bodyBold,
                                          ),
                                          Text(
                                            userProvider.searchUserResult[index].email,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.bodyGrey,
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // send collaboration request
                                        widget.sendCollaborationRequest(
                                            userProvider.searchUserResult[index].id,
                                            "request title",
                                            "request body"); // to be updated
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.send,
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
