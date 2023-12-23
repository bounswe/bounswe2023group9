import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum AnnotationType { theorem, proof }

class AnnotationProvider with ChangeNotifier {
  final List<Annotation> _annotations = [];

  List<Annotation> get annotations => _annotations;

  Future<void> getAnnotations(
      String annotationSourceLocation, List<String> annotationAuthors) async {
    String baseUrl = "${Constants.annotationUrl}/annotations/get_annotation";

    // API can match multiple authors
    // WARNING: not sure exactly how to give it as a list
    // Therefore, constructing query parameters manually
    List<String> queryParams = ['source=$annotationSourceLocation'];

    // Append each author as a separate 'creator' parameter as in Postman
    for (String author in annotationAuthors) {
      queryParams.add('creator=${Uri.encodeQueryComponent(author)}');
    }

    // Join all query parameters with '&' and append to the base URL
    String finalUrl = '$baseUrl?${queryParams.join('&')}';

    try {
      var response = await http.get(Uri.parse(finalUrl));
      if (response.statusCode == 200) {
        List<dynamic> annotationsJson = jsonDecode(response.body);

        _annotations.clear();

        // Parse each JSON object into an Annotation and add to _annotations
        for (var annotationJson in annotationsJson) {
          _annotations.add(Annotation(
            annotationID: int.tryParse(annotationJson['id'].pathSegments.last) ??
                -1, // Adjust according to your JSON structure
            startOffset: annotationJson['target']['selector']['start'],
            endOffset: annotationJson['target']['selector']['end'],
            annotationContent: annotationJson['body']['value'],
            annotationAuthor: annotationJson['creator']['id'],
            sourceLocation: annotationJson['target']['id'],
          ));
        }
        notifyListeners();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addAnnotation(Annotation annotation) async {
    Uri url = Uri.parse("${Constants.annotationUrl}/annotations/create_annotation/");
    var annotationJson = {
      "@context": "http://www.w3.org/ns/anno.jsonld",
      "type": "Annotation",
      "body": {
        "type": "TextualBody",
        "format": "text/html",
        "language": "en",
        "value": annotation.annotationContent,
      },
      "target": {
        "id": annotation.sourceLocation,
        "type": "text",
        "selector": {
          "type": "TextPositionSelector",
          "start": annotation.startOffset,
          "end": annotation.endOffset,
        }
      },
      "creator": {
        "id": annotation.annotationAuthor,
        "type": "Person",
      }
    };

    try {
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(annotationJson),
      );
      if (response.statusCode == 200) {
        annotation.annotationID = _annotations.length + 1;
        _annotations.add(annotation);
        notifyListeners();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }

/*
  Future<void> updateAnnotation(Annotation annotation, String text) async {
    final index =
        _annotations.indexWhere((element) => element.annotationID == annotation.annotationID);
    _annotations[index].annotationContent = text;
    notifyListeners();
  }
*/
}
