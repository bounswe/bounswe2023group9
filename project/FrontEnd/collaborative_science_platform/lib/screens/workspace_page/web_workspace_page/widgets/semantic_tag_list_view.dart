import 'package:collaborative_science_platform/widgets/semantic_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';

class SemanticTagListView extends StatefulWidget {
  final List<SemanticTag> tags;
  final Function addSemanticTags;
  final Function deleteSemanticTag;
  final double height;

  const SemanticTagListView({
    super.key,
    required this.tags,
    required this.addSemanticTags,
    required this.deleteSemanticTag,
    required this.height,
  });

  @override
  State<SemanticTagListView> createState() => _SemanticTagListViewState();
}

class _SemanticTagListViewState extends State<SemanticTagListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Semantic Tags", style: TextStyles.title4secondary),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SemanticSearchBar(addSemanticTags: widget.addSemanticTags),
            
          ),
          SizedBox(
            height: (widget.height * 3) / 5,
            child: ListView.builder(
              itemCount: widget.tags.length,
              shrinkWrap: true,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tags[index].label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.tags[index].description,
                                style: TextStyles.bodyBlack,
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await widget.deleteSemanticTag(widget.tags[index].id);
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
