class ImageAnnotation {
  int? annotationID;
//  String annotationType;
//  String annotationVisibilityType;
//  BasicUser owner;
//  Object annotationLocation;
  String annotationContent;
  String annotationAuthor;
  String
      sourceLocation; // ${Constants.appUrl}/node/{nodeId}%23{theorem|proof}%23{theoremId|proofId}
  DateTime dateCreated;

  ImageAnnotation({
    this.annotationID,
    required this.annotationContent,
    required this.annotationAuthor,
    required this.sourceLocation,
    required this.dateCreated,
  });
}
