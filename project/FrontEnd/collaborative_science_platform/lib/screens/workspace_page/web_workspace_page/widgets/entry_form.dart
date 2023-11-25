import 'package:collaborative_science_platform/utils/colors.dart';
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
  String contentType = "proof";

  final contentController = TextEditingController();

  final contentFocusNode = FocusNode();
  final selectFocusNode = FocusNode();
  @override
  void dispose() {
    contentController.dispose();
    contentFocusNode.dispose();
    selectFocusNode.dispose();
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.tertiaryColor),
              ),
              child: DropdownButton(
                focusNode: selectFocusNode,
                underline: const SizedBox.shrink(),
                focusColor: Colors.white,
                value: contentType,
                items: const [
                  DropdownMenuItem<String>(
                    value: "proof",
                    child: Text("Proof"),
                  ),
                  DropdownMenuItem<String>(
                    value: "theorem",
                    child: Text("Theorem"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    contentType = value!;
                  });
                },
                hint: const Text("Select Content Type"),
              ),
            ),
            SizedBox(
              child: AppTextField(
                controller: contentController,
                focusNode: contentFocusNode,
                hintText: "Content",
                obscureText: false,
                height: 200,
                maxLines: 10,
              ),
            )
          ]),
    );
  }
}
