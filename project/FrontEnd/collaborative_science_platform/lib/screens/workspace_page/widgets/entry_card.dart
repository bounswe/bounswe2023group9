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
  final double height = 80.0;
  bool extended = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: extended? 5*height : height, // A better mechanism is needed here
        child: Card(
          elevation: 4.0,
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            onTap: extended ? () { // Hide the details about the entry
              setState(() {
                extended = false;
              });
            }: () { // Show the details about the entry
              setState(() {
                extended = true;
              });
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.entry.content,
                    maxLines: extended ? 5 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
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
                  extended ? const Icon(Icons.keyboard_arrow_up):
                    const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
