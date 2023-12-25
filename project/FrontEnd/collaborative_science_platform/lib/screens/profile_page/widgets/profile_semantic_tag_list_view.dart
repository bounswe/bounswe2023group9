import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/subsection_title.dart';
import 'package:collaborative_science_platform/widgets/semantic_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/models/workspace_semantic_tag.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/semantic_tag_card.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';

class ProfileSemanticTagListView extends StatefulWidget {
  final List<WorkspaceSemanticTag> tags;
  final Function addUserSemanticTag;
  final Function removeUserSemanticTag;

  const ProfileSemanticTagListView({
    required this.tags,
    required this.addUserSemanticTag,
    required this.removeUserSemanticTag,
    super.key,
  });

  @override
  State<ProfileSemanticTagListView> createState() => _ProfileSemanticTagListViewState();
}

class _ProfileSemanticTagListViewState extends State<ProfileSemanticTagListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SubSectionTitle(title: "Semantic Tags"),
        SemanticSearchBar(addSemanticTag: widget.addUserSemanticTag),
        Text(
          (widget.tags.isNotEmpty) ? "Added Tags" : "You haven't added any tag yet!",
          style: TextStyles.bodySecondary,
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: widget.tags.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SemanticTagCard(
              finalized: false,
              tag: widget.tags[index],
              backgroundColor: const Color.fromARGB(255, 220, 235, 220),
              onDelete: () async {
                await widget.removeUserSemanticTag(widget.tags[index].tagId);
              },
            );
          },
        ),
      ],
    );
  }
}
