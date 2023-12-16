import 'dart:convert';

import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/entry_header.dart';

class MobileEntryCard extends StatefulWidget {
  final Entry entry;
  final void Function() onDelete;
  final Function editEntry;
  final Color backgroundColor;

  const MobileEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.editEntry,
    this.backgroundColor = const Color.fromARGB(255, 220, 235, 220),
  });

  @override
  State<MobileEntryCard> createState() => _MobileEntryCardState();
}

class _MobileEntryCardState extends State<MobileEntryCard> {
  final entryController = TextEditingController();
  final entryFocusNode = FocusNode();

  bool editMode = false;
  bool edited = false;
  String buffer = "";

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
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
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.visibility,
                      color: (editMode) ? Colors.grey : Colors.indigo[600],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12.0),
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
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.edit,
                      color: (!editMode) ? Colors.grey : Colors.indigo[600],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        (editMode) ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
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
            IconButton(
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
        ) : Container(),
      ],
    );
  }

  Widget lowerIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (widget.entry.isEditable) ? IconButton(
          onPressed: () {
            widget.onDelete();
            setState(() { });
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.grey,
          ),
        ) : Container(),
        Text(
          widget.entry.publishDateFormatted,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: CardContainer(
          backgroundColor: widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EntryHeader(entry: widget.entry),
                if (widget.entry.isEditable) upperIconRow(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  ) : Container(
                    constraints: BoxConstraints(
                      minHeight: 100.0, // Set the minimum height here
                      maxHeight: (Responsive.isMobile(context)) ? double.infinity : 400,
                    ),
                    child: TeXView(
                      loadingWidgetBuilder: (context) => const Center(child: CircularProgressIndicator()),
                      renderingEngine: const TeXViewRenderingEngine.katex(),
                      child: TeXViewDocument(
                        utf8.decode(entryController.text.codeUnits),
                      ),
                    ),
                  ),
                ),
                lowerIconRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
