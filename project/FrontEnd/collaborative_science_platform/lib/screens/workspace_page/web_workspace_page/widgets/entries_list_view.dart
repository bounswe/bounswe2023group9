import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/mobile_entry_card.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/new_entry.dart';

class EntriesListView extends StatefulWidget {
  final List<Entry> entries;
  final ScrollController controller;
  final bool showSidebar;
  final double height;
  final Function createNewEntry;
  final Function editEntry;
  final Function deleteEntry;
  final bool finalized;
  final Function setProof;
  final Function setDisproof;
  final Function setTheorem;
  final Function removeDisproof;
  final Function removeTheorem;
  final Function removeProof;
  final bool fromNode;

  const EntriesListView({
    super.key,
    required this.entries,
    required this.controller,
    required this.showSidebar,
    required this.height,
    required this.createNewEntry,
    required this.editEntry,
    required this.deleteEntry,
    required this.finalized,
    required this.removeDisproof,
    required this.removeProof,
    required this.removeTheorem,
    required this.setDisproof,
    required this.setProof,
    required this.setTheorem,
    required this.fromNode,
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
        child: (ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Entries",
                style: TextStyles.title3secondary,
              ),
            ),
            ListView.builder(
                controller: widget.controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return (index != 0)
                      ? MobileEntryCard(
                          finalized: widget.finalized,
                          entry: widget.entries[index - 1],
                          onDelete: () async {
                            await widget.deleteEntry(widget.entries[index - 1].entryId);
                          },
                          editEntry: widget.editEntry,
                          backgroundColor: Colors.white,
                          setProof: widget.setProof,
                          setDisproof: widget.setDisproof,
                          setTheorem: widget.setTheorem,
                          removeProof: widget.removeProof,
                          removeDisproof: widget.removeDisproof,
                          removeTheorem: widget.removeTheorem,
                          deleteEntry: widget.deleteEntry,
                          fromNode: widget.fromNode,
                        )
                      : NewEntry(
                          onCreate: widget.createNewEntry,
                          backgroundColor: const Color.fromARGB(255, 220, 220, 240),
                          isMobile: false,
                          finalized: widget.finalized,
                        );
                }),
            if (widget.entries.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Add Your First Entry!",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 60.0),
          ],
        )),
      ),
    );
  }
}
