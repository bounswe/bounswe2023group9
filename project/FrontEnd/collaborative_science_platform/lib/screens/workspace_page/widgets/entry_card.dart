import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class EntryCard extends StatefulWidget {
  const EntryCard({super.key});

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
        height: height,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Entry Title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
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
