import 'dart:ui';

import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/annotation_provider.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:provider/provider.dart';

class AnnotationText extends StatefulWidget {
  final String text;
  final String annotationSourceLocation;
  final List<String> annotationAuthors;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const AnnotationText(
    this.text,
    this.annotationSourceLocation,
    this.annotationAuthors, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  @override
  State<AnnotationText> createState() => _AnnotationTextState();
}

class _AnnotationTextState extends State<AnnotationText> {
  bool _initState = true;
  bool isLoading = true;
  bool error = false;
  List<Annotation> annotations = [];
  List<int> annotationIndices = [];
  List<bool> annotationOwner = [];
  List<TextSpan> textSpans = [];

  @override
  void didChangeDependencies() {
    if (_initState) {
      getAnnotations();
      _initState = false;
    }
    super.didChangeDependencies();
  }

  void getAnnotations() async {
    try {
      setState(() {
        error = false;
        isLoading = true;
      });
      final annotationProvider = Provider.of<AnnotationProvider>(context);
      final User? user = Provider.of<Auth>(context, listen: false).user;
      final email = user == null ? "" : user.email;
      if (user != null) widget.annotationAuthors.add("http://13.51.205.39/profile/$email");
      await annotationProvider.getAnnotations(
          widget.annotationSourceLocation, widget.annotationAuthors);
      annotations = annotationProvider.annotations;
/*
      for (var element in annotations) {
        annotationIndices.add(element.startOffset);
        annotationIndices.add(element.endOffset);
        element.annotationAuthor = element.annotationAuthor
            .substring(element.annotationAuthor.lastIndexOf("/") + 1)
            .replaceAll("%40", "@");
        print(element.annotationAuthor);
        annotationOwner.add(element.annotationAuthor == email);
      }
      print(annotationIndices);
      print(annotationOwner);

      int textLeftCounter = 0;
      int textRightCounter = 0;
      int annotationCounter = 0;
      while (
          textRightCounter < widget.text.length && annotationCounter < annotationIndices.length) {
        print(annotationOwner[(annotationCounter / 2).round()].toString() + "aaaaa ");
        if (textRightCounter == annotationIndices[annotationCounter]) {
          if (textLeftCounter != textRightCounter) {
            textSpans.add(TextSpan(
              text: widget.text.substring(textLeftCounter, textRightCounter),
              style: widget.style,
            ));
          }
          print(annotationOwner[(annotationCounter / 2).round()]);
          textSpans.add(TextSpan(
            text: widget.text.substring(textRightCounter, annotationIndices[annotationCounter + 1]),
            style: TextStyle(
                backgroundColor: annotationOwner[(annotationCounter / 2).round()]
                    ? Colors.green.withOpacity(0.3)
                    : Colors.yellow.withOpacity(0.3)),
          ));
          textLeftCounter = annotationIndices[annotationCounter + 1];
          textRightCounter = annotationIndices[annotationCounter + 1];
          annotationCounter += 2;
        }
        textRightCounter++;
      }
      if (annotationCounter == annotationIndices.length) {
        textSpans.add(TextSpan(
          text: widget.text.substring(textLeftCounter, widget.text.length),
          style: widget.style,
        ));
      } else if (textLeftCounter != textRightCounter) {
        textSpans.add(TextSpan(
          text: widget.text.substring(textLeftCounter, textRightCounter),
          style: widget.style,
        ));
      }
      if (annotationCounter == 0) {
        textSpans.add(TextSpan(
          text: widget.text,
          style: widget.style,
        ));
      }
*/
// Filter out older annotations in case of overlap
      Map<int, Annotation> mostRecentAnnotations = {};
      for (var annotation in annotations) {
        // Check if there is already an annotation that overlaps
        bool overlap = mostRecentAnnotations.keys.any((key) =>
            (annotation.startOffset < mostRecentAnnotations[key]!.endOffset &&
                annotation.endOffset > mostRecentAnnotations[key]!.startOffset));

        if (overlap) {
          // Find the overlapping annotation
          int overlappingKey = mostRecentAnnotations.keys.firstWhere((key) =>
              (annotation.startOffset < mostRecentAnnotations[key]!.endOffset &&
                  annotation.endOffset > mostRecentAnnotations[key]!.startOffset));

          // Keep the most recent annotation
          if (annotation.dateCreated.isAfter(mostRecentAnnotations[overlappingKey]!.dateCreated)) {
            mostRecentAnnotations[overlappingKey] = annotation;
          }
        } else {
          mostRecentAnnotations[annotation.startOffset] = annotation;
        }
      }

      // Sort the filtered annotations by startOffset
      List<Annotation> sortedAnnotations = mostRecentAnnotations.values.toList();
      sortedAnnotations.sort((a, b) => a.startOffset.compareTo(b.startOffset));

      // Initialize counters
      int textLeftCounter = 0;

      // Iterate over the sorted annotations
      for (var annotation in sortedAnnotations) {
        // Extract email for comparison
        String annotationEmail = annotation.annotationAuthor
            .substring(annotation.annotationAuthor.lastIndexOf("/") + 1)
            .replaceAll("%40", "@");

        // Add non-annotated text span if any
        if (annotation.startOffset > textLeftCounter) {
          textSpans.add(TextSpan(
            text: widget.text.substring(textLeftCounter, annotation.startOffset),
            style: widget.style,
          ));
        }

        // Add annotated text span
        textSpans.add(TextSpan(
          text: widget.text.substring(annotation.startOffset, annotation.endOffset),
          style: TextStyle(
            backgroundColor: annotationEmail == email
                ? Colors.indigo[600]!.withOpacity(0.3)
                : Colors.deepOrangeAccent.withOpacity(0.3),
          ),
        ));

        // Update the left counter
        textLeftCounter = annotation.endOffset;
      }

// Add remaining text if any
      if (textLeftCounter < widget.text.length) {
        textSpans.add(TextSpan(
          text: widget.text.substring(textLeftCounter),
          style: widget.style,
        ));
      }
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : error
            ? const Text(
                "An error occured while initiating explanations! Please try again later.",
                style: TextStyle(color: AppColors.dangerColor),
              )
            : SelectableText.rich(
                TextSpan(
                  children: textSpans,
                ),
                contextMenuBuilder: (context, editableTextState) {
                  var selectedIndices = editableTextState.textEditingValue.selection;
                  String selectedText =
                      editableTextState.textEditingValue.selection.textInside(widget.text);
                  for (var element in annotations) {
                    if (element.startOffset <= selectedIndices.baseOffset &&
                        element.endOffset >= selectedIndices.extentOffset) {
                      return _MyContextMenu(
                        anchor: editableTextState.contextMenuAnchors.primaryAnchor,
                        selectedText: widget.text.substring(element.startOffset, element.endOffset),
                        annotation: element,
                        sourceLocation: widget.annotationSourceLocation,
                        children: AdaptiveTextSelectionToolbar.getAdaptiveButtons(
                          context,
                          editableTextState.contextMenuButtonItems,
                        ).toList(),
                      );
                    }
                  }
                  return _MyContextMenu(
                    anchor: editableTextState.contextMenuAnchors.primaryAnchor,
                    selectedText: selectedText.trim(),
                    startOffset: selectedIndices.baseOffset,
                    endOffset: selectedIndices.extentOffset,
                    sourceLocation: widget.annotationSourceLocation,
                    children: AdaptiveTextSelectionToolbar.getAdaptiveButtons(
                      context,
                      editableTextState.contextMenuButtonItems,
                    ).toList(), //TODO
                  );
                },
              );
  }
}

class _MyContextMenu extends StatelessWidget {
  final Annotation? annotation;
  final int? startOffset;
  final int? endOffset;
  const _MyContextMenu({
    required this.anchor,
    required this.children,
    required this.selectedText,
    required this.sourceLocation,
    this.annotation,
    this.startOffset,
    this.endOffset,
  });

  final Offset anchor;
  final List<Widget> children;
  final String selectedText;
  final String sourceLocation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: anchor.dy,
          left: anchor.dx,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey[900]!.withOpacity(0.7)),
            width: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //...children,
                if (Provider.of<Auth>(context).isSignedIn)
                  AddAnnotationButton(
                      text: selectedText,
                      startOffset: startOffset,
                      endOffset: endOffset,
                      annotation: annotation,
                      sourceLocation: sourceLocation),
                if (annotation != null)
                  Column(
                    children: [
                      const SizedBox(height: 2),
                      ShowAnnotationButton(
                        text: selectedText,
                        annotation: annotation!,
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShowAnnotationButton extends StatelessWidget {
  final String text;
  final Annotation annotation;
  const ShowAnnotationButton({super.key, required this.text, required this.annotation});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: MobileShowAnnotationButton(text, annotation),
        desktop: DesktopShowAnnotationButton(text, annotation));
  }
}

class MobileShowAnnotationButton extends StatefulWidget {
  final String text;
  final Annotation annotation;
  const MobileShowAnnotationButton(this.text, this.annotation, {super.key});

  @override
  State<MobileShowAnnotationButton> createState() => _MobileShowAnnotationButtonState();
}

class _MobileShowAnnotationButtonState extends State<MobileShowAnnotationButton> {
  bool isHovering = false;
  bool isPortalOpen = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        isHovering = true;
        isPortalOpen = true;
      }),
      onExit: (event) => setState(() {
        isHovering = false;
        isPortalOpen = false;
      }),
      child: GestureDetector(
        // Show Popup on Tap
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: Colors.grey[800]!.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                elevation: 20,
                title: Text(
                  widget.text,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                content: SizedBox(
                  height: 200,
                  width: 400,
                  child: Column(
                    children: [
                      SelectableText(
                        widget.annotation.annotationContent,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 5,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        child: AnnotationButtonItem(isHovering: isHovering, text: "Show Annotation"),
      ),
    );
  }
}

class DesktopShowAnnotationButton extends StatefulWidget {
  final String text;
  final Annotation annotation;
  const DesktopShowAnnotationButton(this.text, this.annotation, {super.key});

  @override
  State<DesktopShowAnnotationButton> createState() => _DesktopShowAnnotationButtonState();
}

class _DesktopShowAnnotationButtonState extends State<DesktopShowAnnotationButton> {
  bool isHovering = false;
  bool isPortalOpen = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        isHovering = true;
        isPortalOpen = true;
      }),
      onExit: (event) => setState(() {
        isHovering = false;
        isPortalOpen = false;
      }),
      child: GestureDetector(
        onTap: () => setState(() {
          isHovering = true;
          isPortalOpen = true;
        }),
        child: PortalTarget(
          visible: isPortalOpen,
          fit: StackFit.passthrough,
          anchor: Responsive.isMobile(context)
              ? const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.bottomLeft,
                )
              : const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topRight,
                  backup: Aligned(
                      follower: Alignment.topRight,
                      target: Alignment.topLeft,
                      backup: Aligned(
                        follower: Alignment.bottomRight,
                        target: Alignment.bottomLeft,
                      ))),
          portalFollower: MouseRegion(
            onHover: (event) => setState(() {
              isPortalOpen = true;
            }),
            onEnter: (event) => setState(() {
              isPortalOpen = true;
            }),
            onExit: (event) => setState(() {
              isPortalOpen = false;
            }),
            // design better annotation popup
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[850],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Soft shadow for depth
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              width: 400,
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Text(widget.text,
                        //     style: const TextStyle(fontSize: 16, color: Colors.white)),
                        Container(
                            height: 70,
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: TeXView(
                                child: TeXViewDocument(widget.text,
                                    style: TeXViewStyle(
                                        contentColor: Colors.white,
                                        fontStyle: TeXViewFontStyle(fontSize: 12))))),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SelectableText(widget.annotation.annotationContent,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 12, color: Colors.white))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: AnnotationButtonItem(isHovering: isHovering, text: "Show Annotation"),
        ),
      ),
    );
  }
}

class AddAnnotationButton extends StatefulWidget {
  final String text;
  final int? startOffset;
  final int? endOffset;
  final Annotation? annotation;
  final String sourceLocation;
  const AddAnnotationButton({
    super.key,
    required this.text,
    this.annotation,
    this.startOffset,
    this.endOffset,
    required this.sourceLocation,
  }) : assert(annotation == null ||
            (startOffset == null && endOffset == null) ||
            (startOffset != null && endOffset != null));

  @override
  State<AddAnnotationButton> createState() => _AddAnnotationButtonState();
}

class _AddAnnotationButtonState extends State<AddAnnotationButton> {
  bool isHovering = false;
  bool isPortalOpen = false;
  bool isSaving = false;
  bool change = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.annotation != null) {
      change = true;
      _textEditingController.text = widget.annotation!.annotationContent;
    }
    super.initState();
  }

  _submit(BuildContext context) async {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    var provider = Provider.of<AnnotationProvider>(context, listen: false);
    var navigator = Navigator.of(context);
    if (mounted) {
      setState(() {
        isSaving = true;
      });
    }
    try {
      // no update or remove mechanism implemented yet in backend
      // DELETE this later if it won't be implemented
      if (change) {
        Annotation annotation = Annotation(
          annotationContent: _textEditingController.text,
          startOffset: widget.annotation!.startOffset,
          endOffset: widget.annotation!.endOffset,
          annotationAuthor:
              "http://13.51.205.39/profile/${Provider.of<Auth>(context, listen: false).user!.email}",
          sourceLocation: widget.sourceLocation,
          dateCreated: DateTime.now(),
        );
        await provider.addAnnotation(annotation);
        await provider.deleteAnnotation(widget.annotation!);
      } else {
        Annotation annotation = Annotation(
          annotationContent: _textEditingController.text,
          startOffset: widget.startOffset!,
          endOffset: widget.endOffset!,
          annotationAuthor:
              "http://13.51.205.39/profile/${Provider.of<Auth>(context, listen: false).user!.email}",
          sourceLocation: widget.sourceLocation,
          dateCreated: DateTime.now(),
        );
        await provider.addAnnotation(annotation);
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Something went wrong!"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
      navigator.pop();
    }

    //ContextMenuController.removeAny();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        isHovering = true;
        isPortalOpen = true;
      }),
      onExit: (event) => setState(() {
        isHovering = false;
        isPortalOpen = false;
      }),
      child: GestureDetector(
        // Show Popup on Tap
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return isSaving
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: AlertDialog(
                      backgroundColor: Colors.grey[800]!.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 20,
                      title: TeXView(
                          child: TeXViewDocument(
                        widget.text,
                        style: TeXViewStyle(
                          contentColor: Colors.white,
                          fontStyle: TeXViewFontStyle(fontSize: 14),
                        ),
                      )),
                      content: SizedBox(
                          height: 200,
                          width: 400,
                          child: Column(children: [
                            TextField(
                              controller: _textEditingController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                labelText: 'Annotation',
                                labelStyle: TextStyle(color: Colors.grey[500]),
                              ),
                              maxLines: 5,
                            )
                          ])),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            await _submit(context);
                          },
                          child: const Text('Save', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
          },
        ),
        child: AnnotationButtonItem(
            isHovering: isHovering, text: change ? "Change Annotation" : "Add Annotation"),
      ),
    );
  }
}

class AnnotationButtonItem extends StatelessWidget {
  final bool isHovering;
  final String text;
  const AnnotationButtonItem({super.key, required this.isHovering, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isHovering ? Colors.blue[700] : Colors.transparent,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
