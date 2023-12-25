import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';

class NewEntry extends StatefulWidget {
  final Function onCreate;
  final Color backgroundColor;
  final bool isMobile;
  final bool finalized;

  const NewEntry({
    super.key,
    required this.onCreate,
    required this.backgroundColor,
    required this.isMobile,
    required this.finalized,
  });

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool open = false;
  bool editMode = true;
  bool entryLoading = false;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
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
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                setState(() {
                  entryLoading = true;
                });
                await widget.onCreate(controller.text);
                setState(() {
                  open = false;
                  entryLoading = false;
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
                  open = false;
                });
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget button() {
    return (widget.isMobile)
        ? Center(
            child: IconButton(
              iconSize: 40.0,
              onPressed: widget.finalized
                  ? () {}
                  : () {
                      setState(() {
                        open = true;
                        editMode = true;
                      });
                    },
              icon: Icon(
                Icons.add,
                color: widget.finalized ? Colors.grey[200] : Colors.grey[800],
              ),
            ),
          )
        : Center(
            child: SizedBox(
              width: 300.0,
              child: AppButton(
                isActive: !widget.finalized,
                text: "New Entry",
                height: 40,
                type: "outlined",
                onTap: () {
                  setState(() {
                    open = true;
                    editMode = true;
                  });
                },
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return entryLoading
        ? const Center(child: CircularProgressIndicator())
        : !open
            ? button()
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: CardContainer(
                  backgroundColor: widget.backgroundColor,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Proof or Theorem
                          upperIconRow(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: (editMode)
                                ? TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    cursorColor: Colors.grey.shade700,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: AppColors.primaryColor),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: AppColors.secondaryDarkColor),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  )
                                : Container(
                                    constraints: BoxConstraints(
                                      minHeight: 100.0, // Set the minimum height here
                                      maxHeight:
                                          (Responsive.isMobile(context)) ? double.infinity : 600,
                                    ),
                                    child: SingleChildScrollView(
                                      child: TeXView(
                                        renderingEngine: const TeXViewRenderingEngine.katex(),
                                        child: TeXViewDocument(
                                          utf8.decode(controller.text.codeUnits),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
