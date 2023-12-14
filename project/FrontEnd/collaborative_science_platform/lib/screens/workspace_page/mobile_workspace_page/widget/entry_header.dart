
import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:flutter/material.dart';

class EntryHeader extends StatelessWidget {
  final Entry entry;
  const EntryHeader({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          entry.isTheoremEntry
              ? "Theorem"
              : entry.isProofEntry
              ? "Proof"
              : "",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: entry.isTheoremEntry
                ? Colors.green.shade800
                : entry.isProofEntry
                ? Colors.yellow.shade800
                : Colors.blue.shade800,
          ),
        ),
        if (entry.isFinalEntry)
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
}
