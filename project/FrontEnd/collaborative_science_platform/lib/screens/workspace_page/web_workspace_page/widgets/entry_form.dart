import 'package:collaborative_science_platform/exceptions/workspace_exceptions.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/workspace_provider.dart';
import 'package:collaborative_science_platform/screens/workspace_page/workspaces_page.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryForm extends StatefulWidget {
  final Function() onCreate;
  final int id;
  final bool newEntry;
  final int workspaceId;
  final String content;
  const EntryForm({
    super.key,
    this.id = 0,
    this.newEntry = false,
    required this.workspaceId,
    required this.content,
    required this.onCreate,
  });

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  String contentType = "proof";

  final contentController = TextEditingController();

  final contentFocusNode = FocusNode();
  final selectFocusNode = FocusNode();

  bool _isFirstTime = true;

  bool error = false;
  String errorMessage = "";

  bool isLoading = false;

  @override
  void dispose() {
    contentController.dispose();
    contentFocusNode.dispose();
    selectFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      _isFirstTime = false;
    }
    setState(() {
      if (!widget.newEntry) {
        contentController.text = widget.content;
      }
    });

    super.didChangeDependencies();
  }

  Future<void> createEntry(int workspaceId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.addEntry(contentController.text, workspaceId, auth.token);
      contentController.text = "";
    } on AddEntryException {
      setState(() {
        error = true;
        errorMessage = CreateWorkspaceException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> editEntry(int id) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.editEntry(contentController.text, id, auth.token);
      contentController.text = "";
    } on EditEntryException {
      setState(() {
        error = true;
        errorMessage = EditEntryException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          ),
          SizedBox(
            width: 300,
            child: AppButton(
              text: widget.newEntry ? "Create New Entry" : "Save Entry",
              height: 40,
              onTap: () async {
                if (widget.newEntry) {
                  await createEntry(widget.workspaceId);
                } else {
                  await editEntry(widget.id);
                }
                if (context.mounted) Navigator.of(context).pop();
                widget.onCreate();
              },
            ),
          ),
        ],
      ),
    );
  }
}
