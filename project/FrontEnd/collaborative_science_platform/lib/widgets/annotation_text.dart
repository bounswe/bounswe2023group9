import 'dart:ui';

import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class AnnotationText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const AnnotationText(this.text, {super.key, this.style, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: style,
      maxLines: maxLines,
      showCursor: true,
      textAlign: textAlign,
      contextMenuBuilder: (context, editableTextState) {
        String selectedText = editableTextState.textEditingValue.selection.textInside(text);
        return _MyContextMenu(
          anchor: editableTextState.contextMenuAnchors.primaryAnchor,
          selectedText: selectedText.trim(),
          children: AdaptiveTextSelectionToolbar.getAdaptiveButtons(
            context,
            editableTextState.contextMenuButtonItems,
          ).toList(),
        );
      },
    );
  }
}

class _MyContextMenu extends StatelessWidget {
  const _MyContextMenu({
    required this.anchor,
    required this.children,
    required this.selectedText,
  });

  final Offset anchor;
  final List<Widget> children;
  final String selectedText;

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

                AddAnnotationButton(text: selectedText),
                const SizedBox(height: 2),
                ShowAnnotationButton(text: selectedText),
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
  const ShowAnnotationButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: MobileShowAnnotationButton(text), desktop: DesktopShowAnnotationButton(text));
  }
}

class MobileShowAnnotationButton extends StatefulWidget {
  final String text;
  const MobileShowAnnotationButton(this.text, {super.key});

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
                content: const SizedBox(
                  height: 200,
                  width: 400,
                  child: Column(
                    children: [
                      SelectableText(
                        "Automaton is a relatively self-operating machine.",
                        style: TextStyle(color: Colors.white),
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
  const DesktopShowAnnotationButton(this.text, {super.key});

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
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey[900]!.withOpacity(0.9)),
              width: 400,
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(widget.text,
                            style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const SelectableText("Automaton is a relatively self-operating machine.",
                        style: TextStyle(fontSize: 12, color: Colors.white)),
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
  const AddAnnotationButton({super.key, required this.text});

  @override
  State<AddAnnotationButton> createState() => _AddAnnotationButtonState();
}

class _AddAnnotationButtonState extends State<AddAnnotationButton> {
  bool isHovering = false;
  bool isPortalOpen = false;
  final TextEditingController _textEditingController = TextEditingController();

  void _submit() {
    print(_textEditingController.text);
    ContextMenuController.removeAny();
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
                    onPressed: () {
                      _submit();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
        child: AnnotationButtonItem(isHovering: isHovering, text: "Add Annotation"),
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
