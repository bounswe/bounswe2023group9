abstract class Tag {
  int tagId;
  String tagBody;
  String tagLocation;
  DateTime createdAt;

  Tag({
    required this.tagId,
    required this.tagBody,
    required this.tagLocation,
    required this.createdAt,
  });
}
