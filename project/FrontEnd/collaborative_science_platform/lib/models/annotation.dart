import 'package:collaborative_science_platform/models/annotation_text.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';


class Annotation {
  int annotationID;
  String annotationType;
  String annotationVisibilityType;
  BasicUser owner;
  Object annotationLocation;
  AnnotationText annotationBody;
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
    required this.annotationBody,
    required this.startOffset,
    required this.endOffset,
    required this.createdAt,
    required this.updatedAt,
    });
}
