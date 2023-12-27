import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/annotation_provider.dart';
import 'package:collaborative_science_platform/models/image_annotation.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnnotationImage extends StatefulWidget {
  const AnnotationImage({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  State<AnnotationImage> createState() => _AnnotationImageState();
}

class _AnnotationImageState extends State<AnnotationImage> {
  ImageAnnotation? annotation;

  @override
  initState() {
    super.initState();
    getAnnotation();
  }

  Future<void> getAnnotation() async {
    final AnnotationProvider annotationProvider =
        Provider.of<AnnotationProvider>(context, listen: false);
    await annotationProvider.getImageAnnotations(widget.question);

    annotation = annotationProvider.imageAnnotations
        .firstWhere((element) => element.sourceLocation == widget.question.url);
  }

  Future<void> addAnnotation(String content) async {
    final AnnotationProvider annotationProvider =
        Provider.of<AnnotationProvider>(context, listen: false);
    final User user = Provider.of<Auth>(context, listen: false).user!;
    await annotationProvider.addImageAnnotation(
      ImageAnnotation(
        annotationContent: content,
        annotationAuthor: user.email,
        sourceLocation: widget.question.url!,
        dateCreated: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return annotation == null
        ? AnnotationAddImage(question: widget.question, addAnnotation: addAnnotation)
        : AnnotationExistsImage(annotation: annotation, question: widget.question);
  }
}

class AnnotationAddImage extends StatelessWidget {
  AnnotationAddImage({
    super.key,
    required this.question,
    required this.addAnnotation,
  });

  final TextEditingController annotationController = TextEditingController();
  final Question question;
  final Function(String) addAnnotation;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<Auth>(context).user;
    final bool annotationCondition = user != null;
    return annotationCondition
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Open popup to add annotation
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add an explanation"),
                        content: SizedBox(
                          width: 350,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Annotation',
                            ),
                            controller: annotationController,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              if (annotationController.text.isEmpty) {
                                return;
                              }
                              addAnnotation(annotationController.text);
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      );
                    });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Image.network(
                    question.url!,
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Image.network(
                question.url!,
                alignment: Alignment.centerLeft,
              ),
            ],
          );
  }
}

class AnnotationExistsImage extends StatelessWidget {
  const AnnotationExistsImage({
    super.key,
    required this.question,
    required this.annotation,
  });

  final ImageAnnotation? annotation;
  final Question question;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: annotation!.annotationContent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Image.network(
            question.url!,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }
}
