import 'package:collaborative_science_platform/models/tag.dart';

class WikiTag extends Tag {
  WikiTag({
    required int tagId,
    required String tagBody,
    required String tagLocation,
    required DateTime createdAt
  }) : super(
          tagId: tagId,
          tagBody: tagBody,
          tagLocation: tagLocation,
          createdAt: createdAt
        );
}