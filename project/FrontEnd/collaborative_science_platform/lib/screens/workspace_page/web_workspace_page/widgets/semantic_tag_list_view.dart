import 'package:collaborative_science_platform/models/workspace_semantic_tag.dart';
import 'package:collaborative_science_platform/widgets/semantic_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';

class SemanticTagListView extends StatefulWidget {
  final List<WorkspaceSemanticTag> tags;
  final Function addSemanticTag;
  final Function removeSemanticTag;
  final double height;
  final bool finalized;

  const SemanticTagListView({
    super.key,
    required this.tags,
    required this.addSemanticTag,
    required this.removeSemanticTag,
    required this.height,
    required this.finalized,
  });

  @override
  State<SemanticTagListView> createState() => _SemanticTagListViewState();
}

class _SemanticTagListViewState extends State<SemanticTagListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.height,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Semantic Tags", style: TextStyles.title4secondary),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SemanticSearchBar(addSemanticTag: widget.addSemanticTag),
          ),
          SizedBox(
            // height: (widget.height * 3) / 5,
            child: ListView.builder(
              itemCount: widget.tags.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(3.0),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CardContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.tags[index].label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!widget.finalized)
                        IconButton(
                          onPressed: () async {
                            await widget.removeSemanticTag(widget.tags[index].tagId);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
