import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:flutter/material.dart';

import '../../../models/workspaces_page/entry.dart';
import '../../../utils/colors.dart';

class EntryCard extends StatefulWidget {
  final Entry entry;
  const EntryCard({
    super.key,
    required this.entry,
  });

  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  final double height = 120.0;
  bool extended = false;

  Widget entryHeader() {
    String header = widget.entry.isTheoremEntry ? "Theorem"
        : widget.entry.isProofEntry ? "Proof"
        : widget.entry.isFinalEntry ? "Final"
        : "";
    Color color = widget.entry.isTheoremEntry ? Colors.green.shade800
        : widget.entry.isProofEntry ? Colors.yellow.shade800
        : widget.entry.isFinalEntry ? Colors.red.shade800
        : Colors.blue.shade800;

    return (header != "") ? Text(
      header,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: extended ? 3*height : height,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                entryHeader(),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      widget.entry.content,
                      maxLines: extended ? 10 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (extended) Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dateToString(widget.entry.entryDate),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: extended ? () { // Hide the details about the entry
                        setState(() {
                          extended = false;
                        });
                      }: () { // Show the details about the entry
                        setState(() {
                          extended = true;
                        });
                      },
                      icon: extended ? const Icon(Icons.keyboard_arrow_up):
                      const Icon(Icons.keyboard_arrow_down),
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
