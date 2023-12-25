import 'package:collaborative_science_platform/models/workspace_semantic_tag.dart';
import 'package:flutter/material.dart';

class SemanticTagCard extends StatefulWidget {
  final WorkspaceSemanticTag tag;
  final Function() onDelete;
  final Color backgroundColor;
  final bool finalized;

  const SemanticTagCard({
    required this.tag,
    required this.onDelete,
    required this.backgroundColor,
    required this.finalized,
    super.key,
  });

  @override
  State<SemanticTagCard> createState() => _SemanticTagCardState();
}

class _SemanticTagCardState extends State<SemanticTagCard> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.tag.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (!widget.finalized)
                IconButton(
                  onPressed: () {
                    widget.onDelete();
                    setState(() { });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
