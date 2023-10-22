import 'package:collaborative_science_platform/models/tag.dart';

class SemanticTag extends Tag {
  List<SemanticTag> superTags;
  List<SemanticTag> subTags;

  SemanticTag({
    required int tagId,
    required String tagBody,
    required String tagLocation,
    required DateTime createdAt,
    required this.superTags,
    required this.subTags
  }) : super(
          tagId: tagId,
          tagBody: tagBody,
          tagLocation: tagLocation,
          createdAt: createdAt
        );
}