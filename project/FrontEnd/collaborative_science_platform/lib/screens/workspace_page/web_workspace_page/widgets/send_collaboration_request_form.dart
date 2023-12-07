import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';

class SendCollaborationRequestForm extends StatefulWidget {
  const SendCollaborationRequestForm({super.key});

  @override
  State<SendCollaborationRequestForm> createState() => _SendCollaborationRequestFormState();
}

class _SendCollaborationRequestFormState extends State<SendCollaborationRequestForm> {
  final searchBarFocusNode = FocusNode();
  bool isLoading = false;
  bool firstSearch = false;

  bool error = false;
  String errorMessage = "";

  final messageFieldController = TextEditingController();
  final messageFieldFocusNode = FocusNode();
  ProfileData? selectedContributor;
  int pageIndex = 0;


  @override
  void dispose() {
    searchBarFocusNode.dispose();
    messageFieldController.dispose();
    messageFieldFocusNode.dispose();
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
      height: (pageIndex == 0) ? 600 : (pageIndex == 1) ? 400 : 200,
      child: SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.vertical,
        child: (pageIndex == 0) ? Column(
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
                                        setState(() {
                                          selectedContributor = userProvider.searchUserResult[index];
                                          messageFieldController.text = "Your message to ${selectedContributor?.name} ${selectedContributor?.surname}";
                                          pageIndex = 1;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_right,
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
        ) : (pageIndex == 1) ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      selectedContributor = null;
                      pageIndex = 0;
                    });
                  },
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    "${selectedContributor?.name} ${selectedContributor?.surname}",
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: messageFieldController,
              focusNode: messageFieldFocusNode,
              cursorColor: Colors.grey.shade700,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
              maxLines: 10,
              onChanged: (text) { /* What will happen when the text changes? */ },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.secondaryDarkColor),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            AppButton(
              text: "Send Request",
              type: "primary",
              height: 40.0,
              onTap: () {
                // Send request
                setState(() {
                  pageIndex = 2;
                });
              },
            ),
          ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Text(
              "The collaboration request has been sent to ${selectedContributor?.name} ${selectedContributor?.surname}. Wait for the reply.",
              maxLines: 3,
              style: TextStyles.bodyBlack,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 30.0),
            AppButton(
              text: "Close",
              height: 40.0,
              type: "secondary",
              onTap: () { Navigator.of(context).pop(); },
            ),
          ],
        ),
      ),
    );
  }
}
