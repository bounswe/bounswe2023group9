import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/add_reference_form.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import '../../../../providers/workspace_provider.dart';

class ReferencesListView extends StatelessWidget {
  final List<Node> references;
  final ScrollController controller;
  final double height;
  final int workspaceId;
  const ReferencesListView({
    super.key,
    required this.references,
    required this.controller,
    required this.height,
    required this.workspaceId,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text(
              "References",
              style: TextStyles.title3secondary,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: AppButton(
                text: "Add References",
                height: 40,
                type: "outlined",
                onTap: () {
                  showDialog(
                    context: context,
                      builder: (context) => AppAlertDialog(
                        text: "Add References",
                        content: AddReferenceForm(workspaceId: workspaceId),
                      ),
                  );
                },
              ),
            ),
            SizedBox(
              height: (height * 2) / 3,
              child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(3),
                  itemCount: references.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: CardContainer(
                        onTap: () {
                          context.push("${NodeDetailsPage.routeName}/${references[index].id}");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  references[index].nodeTitle,
                                  style: TextStyles.bodyBold,
                                  textAlign: TextAlign.start,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      try { // A BETTER IMPLEMENTATION IS NEEDED
                                        final auth = Provider.of<Auth>(context, listen: false);
                                        final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
                                        await workspaceProvider.deleteReference(workspaceId, references[index].id, auth.token);
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey[600],
                                    ))
                              ],
                            ),
                            Text(
                              references[index]
                                  .contributors
                                  .map((e) => "by ${e.firstName} ${e.lastName}")
                                  .join(", "),
                              style: TextStyles.bodyGrey,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              references[index].publishDateFormatted,
                              style: TextStyles.bodyGrey,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ]),
        ));
  }
}
