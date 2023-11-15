import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class AnnotationText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  const AnnotationText({super.key, required this.text, this.style, this.textAlign, this.maxLines});

  @override
  State<AnnotationText> createState() => _AnnotationTextState();
}

class _AnnotationTextState extends State<AnnotationText> {
  bool tooltip = false;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      widget.text,
      style: widget.style,
      maxLines: widget.maxLines,
      showCursor: true,
      textAlign: widget.textAlign,
      semanticsLabel: "annotation",
      contextMenuBuilder: (context, editableTextState) {
        String selectedText = editableTextState.textEditingValue.selection.textInside(widget.text);
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
                ...children,
                Divider(
                  height: 3,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 3),
                AddAnnotationButton(text: selectedText),
                ShowAnnotationButton(text: selectedText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShowAnnotationButton extends StatefulWidget {
  final String text;
  const ShowAnnotationButton({super.key, required this.text});

  @override
  State<ShowAnnotationButton> createState() => _ShowAnnotationButtonState();
}

class _ShowAnnotationButtonState extends State<ShowAnnotationButton> {
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
          anchor: const Aligned(
            follower: Alignment.topLeft,
            target: Alignment.topRight,
          ),
          portalFollower: MouseRegion(
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
                    const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.",
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
        child: PortalTarget(
          visible: isPortalOpen,
          anchor: const Aligned(
            follower: Alignment.topLeft,
            target: Alignment.topRight,
          ),
          portalFollower: MouseRegion(
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
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(widget.text, style: const TextStyle(fontSize: 16, color: Colors.white)),
                      Divider(),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ultricies nisl nisl quis nisl.",
                      style: const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
          ),
          child: AnnotationButtonItem(isHovering: isHovering, text: "Add Annotation"),
        ),
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
