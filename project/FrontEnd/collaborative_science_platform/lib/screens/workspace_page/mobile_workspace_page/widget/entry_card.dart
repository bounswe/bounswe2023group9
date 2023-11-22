import 'package:flutter/material.dart';

import '../../../../models/workspaces_page/entry.dart';
import '../../../../utils/colors.dart';

class EntryCard extends StatefulWidget {
  final Entry entry;
  final void Function() onDelete;
  final bool pending;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.pending,
  });

  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  final entryController = TextEditingController();
  final entryFocusNode = FocusNode();

  final double shrunkHeight = 120.0;
  final double extendHeight = 450.0;

  bool extended = false;
  bool readOnly = true;

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
      children: [
        Text(
          widget.entry.isTheoremEntry ? "Theorem"
          : widget.entry.isProofEntry ? "Proof"
          : "",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: widget.entry.isTheoremEntry ? Colors.green.shade800
              : widget.entry.isProofEntry ? Colors.yellow.shade800
              : Colors.blue.shade800,
          ),
        ),
        if (widget.entry.isFinalEntry) Text(
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

  Widget iconRow(bool pending) {
    return !pending ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        readOnly ? IconButton(
          onPressed: () { // Make editable
            setState(() {
              readOnly = false;
            });
          },
          icon: const Icon(Icons.edit),
        ) : Row(
          children: [
            IconButton(
              onPressed: () {
                // Save the changes
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
          onPressed: widget.onDelete, // Delete the entry
          icon: const Icon(Icons.delete),
        ),
        const Expanded(child: SizedBox()),
        Text(
          widget.entry.publishDateFormatted,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    ) : Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.entry.publishDateFormatted,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }

  Widget fullEntryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            readOnly: readOnly,
            controller: entryController,
            focusNode: entryFocusNode,
            cursorColor: Colors.grey.shade700,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 10,
            onChanged: (text) { /* What will happen when the text changes? */ },
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
          ),
        ),
        const SizedBox(height: 10.0),
        iconRow(widget.pending),
      ],
    );
  }

  Widget headerOfContent() {
    return Text(
      widget.entry.content,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
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
          shadowColor: AppColors.primaryColor,
          color: AppColors.primaryLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                entryHeader(),
                extended ? fullEntryContent() : headerOfContent(),
                const Expanded(child: SizedBox()),
                Row(
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
