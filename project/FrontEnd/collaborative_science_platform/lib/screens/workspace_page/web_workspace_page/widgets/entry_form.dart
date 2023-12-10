import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  final int id;
  final bool newEntry;
  final TextEditingController contentController;
  const EntryForm({
    super.key,
    this.id = 0,
    this.newEntry = false,
    required this.contentController,
  });

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final contentFocusNode = FocusNode();
  @override
  void dispose() {
    contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: SizedBox(
              child: AppTextField(
                controller: widget.contentController,
                focusNode: contentFocusNode,
                hintText: "Content",
                obscureText: false,
                height: 200,
                maxLines: 10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
