import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/send_collaboration_request_form.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';

class ContributorsListView extends StatelessWidget {
  final List<User> contributors;
  final List<User> pendingContributors;
  final ScrollController controller;
  final double height;
  final Function updateRequest;
  final Function sendCollaborationRequest;
  final bool finalized;
  const ContributorsListView({
    super.key,
    required this.contributors,
    required this.pendingContributors,
    required this.controller,
    required this.height,
    required this.sendCollaborationRequest,
    required this.updateRequest,
    required this.finalized,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const Text("Contributors", style: TextStyles.title4secondary),
            SizedBox(
              //height: (height * 3) / 5,
              child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(3),
                  itemCount: contributors.length + pendingContributors.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < contributors.length) {
                      return Padding(
                        padding: const EdgeInsets.all(3),
                        child: CardContainer(
                          onTap: () {
                            final String email = contributors[index].email;
                            final String encodedEmail = Uri.encodeComponent(email);
                            context.push('${ProfilePage.routeName}/$encodedEmail');
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${contributors[index].firstName} ${contributors[index].lastName}",
                                style: TextStyles.bodyBold,
                              ),
                              Text(
                                contributors[index].email,
                                style: TextStyles.bodyGrey,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(3),
                        child: CardContainer(
                          onTap: () {
                            final String email =
                                pendingContributors[index - contributors.length].email;
                            final String encodedEmail = Uri.encodeComponent(email);
                            context.push('${ProfilePage.routeName}/$encodedEmail');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${pendingContributors[index - contributors.length].firstName} ${pendingContributors[index - contributors.length].lastName}",
                                      style: TextStyles.bodyBold,
                                    ),
                                    Text(
                                      pendingContributors[index - contributors.length].email,
                                      style: TextStyles.bodyGrey,
                                    )
                                  ],
                                ),
                              ),
                              if (!finalized)
                                Column(children: [
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.clear_circled,
                                      color: AppColors.warningColor,
                                    ),
                                    onPressed: () async {
                                      // function to delete collaboration request
                                      //TODO - requests id's are absent for now.
                                      await updateRequest(
                                          pendingContributors[index - contributors.length]
                                              .requestId,
                                          RequestStatus.rejected);
                                    },
                                  ),
                                ])
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: AppButton(
                isActive: !finalized,
                text: "Collaborate",
                height: 40,
                type: "outlined",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppAlertDialog(
                      text: "Send Collaboration Request",
                      content: SendCollaborationRequestForm(
                          sendCollaborationRequest: sendCollaborationRequest),
                    ),
                  );
                },
              ),
            ),
          ])),
    );
  }
}
