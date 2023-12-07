import 'dart:convert';

import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../../../../models/workspaces_page/entry.dart';
import '../../../../utils/colors.dart';
import 'entry_header.dart';


class EntryCard extends StatefulWidget {
  final Entry entry;
  final void Function() onDelete;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  final entryController = TextEditingController();
  final entryFocusNode = FocusNode();

  final double shrunkHeight = 200.0;
  final double extendHeight = 540.0;

  String buffer = "";
  bool extended = false;
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () { // Preview Mode
            setState(() {
              editMode = false;
            });
          },
          icon: Icon(
            Icons.visibility,
            color: (!editMode) ? Colors.indigo[600] : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () { // Edit Mode
            setState(() {
              if (!edited) {
                buffer = entryController.text;
              }
              editMode = true;
            });
          },
          icon: Icon(
            Icons.edit,
            color: (editMode) ? Colors.indigo[600] : Colors.grey,
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
    );
  }

  Widget lowerIconRow() {
    return Row(
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
        const Expanded(child: SizedBox()),
        Text(
          widget.entry.publishDateFormatted,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }

  Widget fullEntryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
          ) : SizedBox(
            height: 300.0,
            child: CardContainer(
              backgroundColor: const Color.fromARGB(255, 180, 240, 210),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: TeXView(
                    renderingEngine: const TeXViewRenderingEngine.katex(),
                    child: TeXViewDocument(
                      utf8.decode(entryController.text.codeUnits),
                    )
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 6.0),
            Text(
              "name surname (email)",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        lowerIconRow(),
      ],
    );
  }

  Widget headerOfContent() { // Print the first line
    int index = entryController.text.indexOf('\n', 0);
    String head = entryController.text.substring(0, (index != -1) ? index : entryController.text.length);
    return TeXView(
        renderingEngine: const TeXViewRenderingEngine.katex(),
        child: TeXViewDocument(
          utf8.decode(head.codeUnits),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: extended ? extendHeight : shrunkHeight,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EntryHeader(entry: widget.entry),
                extended ? fullEntryContent() : headerOfContent(),
                const Expanded(child: SizedBox()),
                Row( // It is added to center the widget
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          extended = !extended;
                        });
                      },
                      icon: extended
                          ? const Icon(Icons.keyboard_arrow_up)
                          : const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
