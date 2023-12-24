import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/add_reference_form.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReferencesListView extends StatelessWidget {
  final List<Node> references;
  final ScrollController controller;
  final double height;
  final Function addReference;
  final Function deleteReference;
  final bool finalized;
  const ReferencesListView({
    super.key,
    required this.references,
    required this.controller,
    required this.height,
    required this.addReference,
    required this.deleteReference,
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
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text(
              "References",
              style: TextStyles.title4secondary,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: AppButton(
                isActive: !finalized,
                text: (MediaQuery.of(context).size.width > Responsive.desktopPageWidth)
                    ? "Add References"
                    : "Add",
                height: 40,
                type: "outlined",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppAlertDialog(
                      text: "Add References",
                      content: AddReferenceForm(onAdd: addReference),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: (height * 3) / 5,
              child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(3),
                  physics: const NeverScrollableScrollPhysics(),
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Text(
                                    references[index].nodeTitle,
                                    style: TextStyles.bodyBold,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                if (!finalized &&
                                    MediaQuery.of(context).size.width > Responsive.desktopPageWidth)
                                  IconButton(
                                    onPressed: () async {
                                      //remove reference
                                      await deleteReference(references[index].id);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey[600],
                                    ),
                                  )
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: AppButton(
                text: (MediaQuery.of(context).size.width > Responsive.desktopPageWidth) ? "Add References" : "Add",
                height: 40,
                type: "outlined",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppAlertDialog(
                      text: "Add References",
                      content: AddReferenceForm(onAdd: addReference),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
