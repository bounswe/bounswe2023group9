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
    List<String> queryParams = [
      'source=${Uri.encodeQueryComponent(annotationSourceLocation)}'
          .replaceAll('%2F', '/')
          .replaceAll('%3A', ':')
    ];

    // Append each author as a separate 'creator' parameter as in Postman
    for (String author in annotationAuthors) {
      queryParams.add('creator=${Uri.encodeQueryComponent(author)}'
          .replaceAll('%2F', '/')
          .replaceAll('%3A', ':'));
    }

    // Join all query parameters with '&' and append to the base URL
    String finalUrl = '$baseUrl?${queryParams.join('&')}';
    print(finalUrl);

    try {
      var response = await http.get(Uri.parse(finalUrl));
      print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 404) {
        // no annotations found
        _annotations.clear();
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        List<dynamic> annotationsJson = jsonDecode(response.body);

        _annotations.clear();

        // Parse each JSON object into an Annotation and add to _annotations
        for (var annotationJson in annotationsJson) {
          Uri idUri = Uri.parse(annotationJson['id']);
          _annotations.add(Annotation(
            annotationID: int.tryParse(idUri.pathSegments.last) ??
                -1, // Adjust according to your JSON structure
            startOffset: annotationJson['target']['selector']['start'],
            endOffset: annotationJson['target']['selector']['end'],
            annotationContent: annotationJson['body']['value'],
            annotationAuthor: annotationJson['creator']['id'],
            sourceLocation: annotationJson['target']['id'],
            dateCreated: DateTime.parse(annotationJson['created']),
          ));
          print(annotationJson['body']['value']);
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
    print("debugging myself");
    print(annotation.annotationContent);
    print(annotation.sourceLocation);
    print(annotation.annotationAuthor);
    print(annotation.startOffset);
    print(annotation.endOffset);
    Uri url = Uri.parse("${Constants.annotationUrl}/annotations/create_annotation/");
    /*
    var annotationJson = {
      "@context": "http://www.w3.org/ns/anno.jsonld",
      "type": "Annotation",
      "body": jsonEncode({
        // Convert the body object to a JSON string
        "type": "TextualBody",
        "format": "text/html",
        "language": "en",
        "value": annotation.annotationContent,
      }),
      "target": jsonEncode({
        // Convert the target object to a JSON string
        "id": annotation.sourceLocation,
        "type": "text",
        "selector": {
          "type": "TextPositionSelector",
          "start": annotation.startOffset,
          "end": annotation.endOffset,
        }
      }),
      "creator": jsonEncode({
        // Convert the creator object to a JSON string
        "id": annotation.annotationAuthor,
        "type": "Person",
      })
    };
    print('Sending JSON: ${jsonEncode(annotationJson)}');
    */
    var request = http.MultipartRequest('POST', url);

// Add each field as a string
    request.fields['@context'] = "http://www.w3.org/ns/anno.jsonld";
    request.fields['type'] = "Annotation";
    request.fields['body'] = jsonEncode({
      "type": "TextualBody",
      "format": "text/html",
      "language": "en",
      "value": annotation.annotationContent,
    });
    request.fields['target'] = jsonEncode({
      "id": annotation.sourceLocation,
      "type": "text",
      "selector": {
        "type": "TextPositionSelector",
        "start": annotation.startOffset,
        "end": annotation.endOffset,
      }
    });
    request.fields['creator'] = jsonEncode({
      "id": annotation.annotationAuthor,
      "type": "Person",
    });
    try {
      var response = await request.send();
      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
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

  Future<void> deleteAnnotation(Annotation annotation) async {
    Uri url =
        Uri.parse("${Constants.annotationUrl}/annotations/annotation/${annotation.annotationID}");
    try {
      var response = await http.delete(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 204 || response.statusCode == 201 || response.statusCode == 200) {
        print("Annotation deleted");
        _annotations.remove(annotation);
        notifyListeners();
      } else {
        throw Exception("Something has happened");
      }
    } catch (e) {
      rethrow;
    }
  }
}
