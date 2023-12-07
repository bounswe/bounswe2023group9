import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/entry_form.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/web_entry_card.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../mobile_workspace_page/widget/app_alert_dialog.dart';

class EntriesListView extends StatelessWidget {
  final List<Entry> entries;
  final ScrollController controller;
  final bool showSidebar;
  final double height;
  const EntriesListView(
      {super.key,
      required this.entries,
      required this.controller,
      required this.showSidebar,
      required this.height,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      width: showSidebar
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: (Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              const Text(
                "Entries",
                style: TextStyles.title3secondary,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: AppButton(
                  text: (MediaQuery.of(context).size.width < Responsive.desktopPageWidth) ? "New Entry" : "Create New Entry",
                  height: 40,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppAlertDialog(
                        text: "New Entry",
                        content: const EntryForm(newEntry: true),
                        actions: [
                          AppButton(
                            text: "Create New Entry",
                            height: 40,
                            onTap: () { /* Create new Entry */ },
                          ),
                        ],
                      ),
                    );
                  },
                  type: "outlined",
                ),
              ),
            ]),
            if (entries.isNotEmpty)
            ListView.builder(
                controller: controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return WebEntryCard(
                      entry: entries[index],
                      onDelete: () { /* write delete function here */ },
                    );
                })
            else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "No Entries Yet!",
                  style: TextStyles.bodyGrey,
                ),
              )
              
          ],
        )),
      ),
    );
  }
}
