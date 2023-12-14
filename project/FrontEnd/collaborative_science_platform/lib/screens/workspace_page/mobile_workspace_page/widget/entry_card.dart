import 'dart:convert';

import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import '../../../../models/workspaces_page/entry.dart';
import '../../../../utils/colors.dart';

class EntryCard extends StatefulWidget {
  final Entry entry;
  final void Function() onDelete;
  final bool pending;
  final Function editEntry;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.pending,
    required this.editEntry,
  });

  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  final entryController = TextEditingController();
  final entryFocusNode = FocusNode();

  bool editMode = false;
  bool edited = false;
  String buffer = "";

  bool readOnly = false;

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

  Widget entryHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.entry.isTheoremEntry
              ? "Theorem"
              : widget.entry.isProofEntry
                  ? "Proof"
                  : "",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: widget.entry.isTheoremEntry
                ? Colors.green.shade800
                : widget.entry.isProofEntry
                    ? Colors.yellow.shade800
                    : Colors.blue.shade800,
          ),
        ),
        if (widget.entry.isFinalEntry)
          Text(
            " (Final)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: Colors.red.shade800,
            ),
          ),
      ],
    );
  }

  Widget upperIconRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Preview",
                    style: TextStyle(
                      color: (editMode) ? Colors.grey : Colors.indigo[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Icon(
                    Icons.visibility,
                    color: (editMode) ? Colors.grey : Colors.indigo[600],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 10.0),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Write",
                    style: TextStyle(
                      color: (!editMode) ? Colors.grey : Colors.indigo[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Icon(
                    Icons.edit,
                    color: (!editMode) ? Colors.grey : Colors.indigo[600],
                  )
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          if (editMode) IconButton(
            onPressed: () async {
              await widget.editEntry(entryController.text, widget.entry.entryId);
              setState(() {
                editMode = false;
                edited = false;
              });
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
          if (editMode) IconButton(
            onPressed: () {
              setState(() {
                editMode = false;
                edited = false;
                entryController.text = buffer;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              widget.onDelete();
              setState(() {

              });
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
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
        ],
      ),
    );
  }

  Widget iconRow(bool pending) {
    return !pending
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              readOnly
                  ? IconButton(
                      onPressed: () {
                        // Make editable
                        setState(() {
                          readOnly = false;
                        });
                      },
                      icon: const Icon(Icons.edit),
                    )
                  : Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            // Save the changes

                            await widget.editEntry(entryController.text, widget.entry.entryId);

                            setState(() {
                              readOnly = true;
                            });
                          },
                          icon: const Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () {
                            // Do not save the changes
                            setState(() {
                              readOnly = true;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppAlertDialog(
                      text: "Do you want to delete the entry?",
                      actions: [
                        AppButton(
                          text: "Yes",
                          height: 40,
                          onTap: () {
                            // delete the entry
                            widget.onDelete();
                            setState(() {

                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        AppButton(
                          text: "No",
                          height: 40,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
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
          )
        : Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
            ),
          );
  }

  Widget entryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        upperIconRow(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: (editMode) ? TextField(
            controller: entryController,
            focusNode: entryFocusNode,
            cursorColor: Colors.grey.shade700,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
            maxLines: 10,
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
          ) : Card(
            color: const Color.fromARGB(255, 220, 240, 240),
            child: TeXView(
              renderingEngine: const TeXViewRenderingEngine.katex(),
              child: TeXViewDocument(
                utf8.decode(entryController.text.codeUnits),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        lowerIconRow(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              entryHeader(),
              entryContent(),
            ],
          ),
        ),
      ),
    );
  }
}
