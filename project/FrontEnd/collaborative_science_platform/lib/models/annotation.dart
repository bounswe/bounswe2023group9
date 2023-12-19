class Annotation {
  int? annotationID;
//  String annotationType;
//  String annotationVisibilityType;
//  BasicUser owner;
//  Object annotationLocation;
  String annotationContent;
  String annotationAuthor;
  int startOffset;
  int endOffset;

  Annotation({
    this.annotationID,
    required this.startOffset,
    required this.endOffset,
    required this.annotationContent,
    required this.annotationAuthor,
  });
}
