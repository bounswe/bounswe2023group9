class Annotation {
  int? annotationID;
//  String annotationType;
//  String annotationVisibilityType;
//  BasicUser owner;
//  Object annotationLocation;
  String annotationContent;
  String annotationAuthor;
  String
      sourceLocation; // ${Constants.appUrl}/node/{nodeId}%23{theorem|proof}%23{theoremId|proofId}
  int startOffset;
  int endOffset;

  Annotation({
    this.annotationID,
    required this.startOffset,
    required this.endOffset,
    required this.annotationContent,
    required this.annotationAuthor,
    required this.sourceLocation,
  });
}
