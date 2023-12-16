import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/providers/user_provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_science_platform/utils/colors.dart';

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
  final messageTitleController = TextEditingController();
  final messageTitleFocusNode = FocusNode();
  final messageBodyController = TextEditingController();
  final messageBodyFocusNode = FocusNode();
  final searchBarFocusNode = FocusNode();
  bool isLoading = false;
  bool firstSearch = false;

  ProfileData user = ProfileData();
  bool error = false;
  String errorMessage = "";
  int page = 0;
  bool sendingRequest = false;

  @override
  void dispose() {
    messageTitleController.dispose();
    messageTitleFocusNode.dispose();
    messageBodyController.dispose();
    messageBodyFocusNode.dispose();
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
        child: (page == 0) ? Column(
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
                                        user = userProvider.searchUserResult[index];
                                        setState(() {
                                          page = 1;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
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
        ) : (page == 1) ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      page = 0;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "To ${user.name} ${user.surname}",
                  style: TextStyles.title4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            AppTextField(
              controller: messageTitleController,
              focusNode: messageTitleFocusNode,
              hintText: "Subject",
              obscureText: false,
              maxLines: 1,
              height: 60.0,
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: messageBodyController,
              focusNode: messageBodyFocusNode,
              hintText: "Write an expressive message!",
              obscureText: false,
              maxLines: 10,
              height: 300.0,
            ),
            AppButton(
              text: "Send",
              height: 50.0,
              type: "outlined",
              isLoading: sendingRequest,
              onTap: () async {
                setState(() {
                  sendingRequest = true;
                });
                await widget.sendCollaborationRequest(user.id, messageTitleController.text, messageBodyController.text);
                setState(() {
                  page = 2;
                  sendingRequest = false;
                });
              },
            ),
          ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "The collaboration request has been sent to ${user.name} ${user.surname} successfully.",
              style: TextStyles.bodyBlack,
            ),
            const SizedBox(height: 10.0),
            Text(
              messageTitleController.text,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              messageBodyController.text,
              style: TextStyles.title4,
            ),
            const SizedBox(height: 10.0),
            AppButton(
              text: "Close",
              height: 40.0,
              type: "secondary",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
