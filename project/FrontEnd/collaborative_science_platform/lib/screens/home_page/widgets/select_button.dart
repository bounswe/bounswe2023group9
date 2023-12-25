import 'package:flutter/material.dart';

class SelectButton extends StatefulWidget {
  final int index;
  final String name;
  final bool selected;
  final Function onPressed;
  const SelectButton(
      {required this.index,
      required this.name,
      required this.selected,
      required this.onPressed,
      super.key});

  @override
  State<SelectButton> createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => isHovering = true),
      onExit: (event) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () {
          widget.onPressed(widget.index);
        },
        child: Container(
          height: 35,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: widget.selected
                ? Colors.indigo[600]
                : isHovering
                    ? Colors.indigo[200]
                    : Colors.grey[200],
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectionContainer.disabled(
                child: Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.selected ? Colors.white : Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
