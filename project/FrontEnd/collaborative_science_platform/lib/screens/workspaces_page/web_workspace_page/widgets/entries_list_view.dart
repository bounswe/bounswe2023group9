import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/widgets/entry_form.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

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
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
                style: TextStyles.title2secondary,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: AppButton(
                  text: "Create New Entry",
                  height: 40,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const SizedBox(
                                width: 500,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('New Entry', style: TextStyle(fontSize: 20.0)),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.white,
                              shadowColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              content: const EntryForm(newEntry: true),
                              actions: [
                                AppButton(text: "Create New Entry", height: 40, onTap: () {}),
                              ],
                            ));
                  },
                  type: "outlined",
                ),
              ),
            ]),
            ListView.builder(
                controller: controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: CardContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entries[index].isProofEntry
                                    ? "Proof"
                                    : (entries[index].isTheoremEntry ? "Theorem" : ""),
                                style: TextStyles.bodyGrey,
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (entries[index].isEditable)
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const SizedBox(
                                                      width: 500,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Edit Entry',
                                                              style: TextStyle(fontSize: 20.0)),
                                                        ],
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.white,
                                                    shadowColor: Colors.white,
                                                    surfaceTintColor: Colors.white,
                                                    content: EntryForm(id: entries[index].entryId),
                                                    actions: [
                                                      AppButton(
                                                          text: "Save Entry",
                                                          height: 40,
                                                          onTap: () {}),
                                                    ],
                                                  ));
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey[600],
                                        )),
                                  if (entries[index].isEditable)
                                    IconButton(
                                        onPressed: () {
                                          //edit entry
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey[600],
                                        ))
                                ],
                              )
                            ],
                          ),
                          Text(
                            entries[index].content,
                            style: TextStyles.bodyBlack,
                            textAlign: TextAlign.start,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entries[index].isFinalEntry ? "Finalized" : "",
                                style: TextStyles.bodyGrey,
                              ),
                              Text(
                                entries[index].publishDateFormatted,
                                style: TextStyles.bodyGrey,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        )),
      ),
    );
  }
}
