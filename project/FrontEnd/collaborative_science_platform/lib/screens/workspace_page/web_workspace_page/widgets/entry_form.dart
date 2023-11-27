import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  final int id;
  final bool newEntry;
  const EntryForm({super.key, this.id = 0, this.newEntry = false});

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final contentController = TextEditingController();

  final contentFocusNode = FocusNode();
  @override
  void dispose() {
    contentController.dispose();
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
            Expanded(
              child: SizedBox(
                child: AppTextField(
                  controller: contentController,
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
