import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class CreateWorkspaceForm extends StatefulWidget {
  final TextEditingController titleController;
  const CreateWorkspaceForm({super.key, required this.titleController});

  @override
  State<CreateWorkspaceForm> createState() => _CreateWorkspaceFormState();
}

class _CreateWorkspaceFormState extends State<CreateWorkspaceForm> {

  final titleFocusNode = FocusNode();

  @override
  void dispose() {
    titleFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextField(
              controller: widget.titleController,
              focusNode: titleFocusNode,
              hintText: 'Workspace Title',
              obscureText: false,
              height: 64,
            ),
          ],
        ));
  }
}
