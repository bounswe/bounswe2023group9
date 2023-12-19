import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:flutter/material.dart';

enum AnnotationType { theorem, proof }

class AnnotationProvider with ChangeNotifier {
  final List<Annotation> _annotations = [];

  List<Annotation> get annotations => _annotations;

  Future<void> getAnnotations(AnnotationType annotationType) async {
    _annotations.clear();
    if (AnnotationType.theorem == annotationType) {
      _annotations.add(
        Annotation(
          annotationID: 1,
          annotationContent: "This is an integral.",
          annotationAuthor: "Author",
          startOffset: 0,
          endOffset: 36,
        ),
      );
    } else if (AnnotationType.proof == annotationType) {
      _annotations.add(
        Annotation(
          annotationID: 1,
          annotationContent: "You need to be carefull here.",
          annotationAuthor: "Author",
          startOffset: 152,
          endOffset: 303,
        ),
      );
    }
  }

  Future<void> addAnnotation(Annotation annotation) async {
    annotation.annotationID = _annotations.length + 1;
    _annotations.add(annotation);
    notifyListeners();
  }

  Future<void> updateAnnotation(Annotation annotation, String text) async {
    final index =
        _annotations.indexWhere((element) => element.annotationID == annotation.annotationID);
    _annotations[index].annotationContent = text;
    notifyListeners();
  }
}
