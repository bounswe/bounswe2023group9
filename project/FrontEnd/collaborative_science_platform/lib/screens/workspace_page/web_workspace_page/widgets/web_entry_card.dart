import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../../../../models/workspaces_page/entry.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/card_container.dart';
import '../../mobile_workspace_page/widget/app_alert_dialog.dart';
import '../../mobile_workspace_page/widget/entry_header.dart';

class WebEntryCard extends StatefulWidget {
  final Entry entry;
  final void Function() onDelete;

  const WebEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  State<WebEntryCard> createState() => _WebEntryCardState();
}

class _WebEntryCardState extends State<WebEntryCard> {
  final entryController = TextEditingController();
  final entryFocusNode = FocusNode();

  String buffer = "";
  bool editMode = false;
  bool edited = false;

  @override
  void initState() {
    super.initState();
    entryController.text = widget.entry.content;
  }

  @override
  void dispose() {
    entryController.dispose();
    entryFocusNode.dispose();
    super.dispose();
  }

  Widget upperIconRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  editMode = false;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Text(
                      "Preview",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: (!editMode) ? Colors.indigo[600] : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Icon(
                      Icons.visibility,
                      color: (!editMode) ? Colors.indigo[600] : Colors.grey,
                    ),
                  ],
                )
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (!edited) {
                    buffer = entryController.text;
                  }
                  editMode = true;
                });
              },
              child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Text(
                        "Write",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: (editMode) ? Colors.indigo[600] : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Icon(
                        Icons.edit,
                        color: (editMode) ? Colors.indigo[600] : Colors.grey,
                      ),
                    ],
                  )
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          if (editMode) IconButton(
            onPressed: () {
              // Save the changes
              setState(() {
                edited = false;
                editMode = false;
              });
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
          if (editMode) IconButton(
            onPressed: () {
              // Do not save the changes
              setState(() {
                entryController.text = buffer;
                edited = false;
                editMode = false;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget lowerIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  AppAlertDialog(
                    text: "Do you want to delete the entry?",
                    actions: [
                      AppButton(
                        text: "Yes",
                        height: 40,
                        onTap: () {
                          setState(() { // delete the entry
                            widget.onDelete();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      AppButton(
                        text: "No",
                        height: 40,
                        onTap: () { Navigator.of(context).pop(); },
                      ),
                    ],
                  ),
            );
          },
          icon: const Icon(Icons.delete),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AppAlertDialog(
                text: "Do you want to finalize the entry?",
                actions: [
                  AppButton(
                    text: "Yes",
                    height: 40,
                    onTap: () {
                      /* Finalize the entry */
                      Navigator.of(context).pop();
                    },
                  ),
                  AppButton(
                    text: "No",
                    height: 40,
                    onTap: () { Navigator.of(context).pop(); },
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.stop),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: CardContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntryHeader(entry: widget.entry),
            upperIconRow(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (editMode) ? TextField(
                controller: entryController,
                focusNode: entryFocusNode,
                cursorColor: Colors.grey.shade700,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
                maxLines: 11,
                onChanged: (text) { edited = true; },
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
              ) : TeXView(
                renderingEngine: const TeXViewRenderingEngine.katex(),
                child: TeXViewDocument(
                  utf8.decode(entryController.text.codeUnits),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "name surname (email)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            lowerIconRow(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.entry.isFinalEntry ? "Finalized" : "",
                  style: TextStyles.bodyGrey,
                ),
                Text(
                  widget.entry.publishDateFormatted,
                  style: TextStyles.bodyGrey,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
