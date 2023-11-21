import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/widgets/send_collaboration_request_form.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContributorsListView extends StatelessWidget {
  final List<User> contributors;
  final ScrollController controller;
  final double height;
  const ContributorsListView(
      {super.key, required this.contributors, required this.controller, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const Text("Contributors", style: TextStyles.title3secondary),
            SizedBox(
              height: (height * 2) / 3,
              child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(3),
                  itemCount: contributors.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: CardContainer(
                        onTap: () {
                          final String email = contributors[index].email;
                          final String encodedEmail = Uri.encodeComponent(email);
                          context.push('${ProfilePage.routeName}/$encodedEmail');
                        },
                        child: Column(
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
                  }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: AppButton(
                text: "Send Collaboration Request",
                height: 40,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: SizedBox(
                              width: 500,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Send Collaboration Request',
                                      style: TextStyle(fontSize: 20.0)),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.white,
                            shadowColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            content: SendCollaborationRequestForm(),
                          ));
                },
                type: "outlined",
              ),
            ),
          ])),
    );
  }
}
