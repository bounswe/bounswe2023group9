import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/mobile_entry_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/entry_form.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

import '../../mobile_workspace_page/widget/app_alert_dialog.dart';
import '../../mobile_workspace_page/widget/entry_header.dart';
import '../../mobile_workspace_page/widget/new_entry.dart';

class EntriesListView extends StatefulWidget {
  final List<Entry> entries;
  final ScrollController controller;
  final bool showSidebar;
  final double height;
  final Function createNewEntry;
  final Function editEntry;
  final Function deleteEntry;
  const EntriesListView({
    super.key,
    required this.entries,
    required this.controller,
    required this.showSidebar,
    required this.height,
    required this.createNewEntry,
    required this.editEntry,
    required this.deleteEntry,
  });
  @override
  State<EntriesListView> createState() => _EntriesListViewState();
}

class _EntriesListViewState extends State<EntriesListView> {
  TextEditingController contentController = TextEditingController();

  bool entryLoading = false;
  @override
  Widget build(BuildContext context) {
    int length = widget.entries.length;
    return Container(
      height: widget.height,
      width: widget.showSidebar
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: (
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Entries",
              style: TextStyles.title3secondary,
            ),
            if (widget.entries.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    controller: widget.controller,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: length+1,
                    itemBuilder: (BuildContext context, int index) {
                      return (index != 0) ? MobileEntryCard(
                        entry: widget.entries[index-1],
                        onDelete: () async {
                          await widget.deleteEntry(widget.entries[index-1].entryId);
                        },
                        editEntry: widget.editEntry,
                        backgroundColor: Colors.white,
                      ) : NewEntry(
                        onCreate: widget.createNewEntry,
                        backgroundColor: const Color.fromARGB(255, 220, 220, 240),
                        isMobile: false,
                      );
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
                                  EntryHeader(entry: widget.entries[index]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (widget.entries[index].isEditable)
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AppAlertDialog(
                                                  text: "Edit Entry",
                                                  content: EntryForm(
                                                    id: widget.entries[index].entryId,
                                                    contentController: contentController,
                                                  ),
                                                  actions: [
                                                    AppButton(
                                                      text: "Save Entry",
                                                      height: 40,
                                                      onTap: () async {
                                                        await widget.editEntry(contentController.text,
                                                            widget.entries[index].entryId);
                                                        contentController.text = "";
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.grey[600],
                                            )),
                                      if (widget.entries[index].isEditable)
                                        IconButton(
                                            onPressed: () async {
                                              await widget.deleteEntry(widget.entries[index].entryId);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.grey[600],
                                            ),
                                        )
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                widget.entries[index].content,
                                style: TextStyles.bodyBlack,
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.entries[index].isFinalEntry ? "Finalized" : "",
                                    style: TextStyles.bodyGrey,
                                  ),
                                  Text(
                                    widget.entries[index].publishDateFormatted,
                                    style: TextStyles.bodyGrey,
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "No Entries Yet!",
                  style: TextStyles.bodyGrey,
                ),
              ),
            const SizedBox(height: 60.0),
          ],
        )),
      ),
    );
  }
}
