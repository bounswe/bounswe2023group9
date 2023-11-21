import 'package:collaborative_science_platform/models/basic_user.dart';

class Annotation {
  int annotationID;
  String annotationType;
  String annotationVisibilityType;
  BasicUser owner;
  Object annotationLocation;
  int startOffset;
  int endOffset;
  DateTime createdAt;
  DateTime updatedAt;

  Annotation({
    required this.annotationID,
    required this.annotationType,
    required this.annotationVisibilityType,
    required this.owner,
    required this.annotationLocation,
    required this.startOffset,
    required this.endOffset,
    required this.createdAt,
    required this.updatedAt,
  });
}
