import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../exceptions/workspace_exceptions.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/workspace_provider.dart';
import '../../../../widgets/app_button.dart';

class CreateWorkspaceForm extends StatefulWidget {
  final Function() onCreate;
  const CreateWorkspaceForm({
    super.key,
    required this.onCreate,
  });

  @override
  State<CreateWorkspaceForm> createState() => _CreateWorkspaceFormState();
}

class _CreateWorkspaceFormState extends State<CreateWorkspaceForm> {
  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();

  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> addNewWorkspace(String title) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      await workspaceProvider.createWorkspace(title, auth.token);
    } on CreateWorkspaceException {
      setState(() {
        error = true;
        errorMessage = CreateWorkspaceException().message;
      });
    } on WorkspacePermissionException {
      setState(() {
        error = true;
        errorMessage = WorkspacePermissionException().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = e.toString();
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
        height: 200,
        child: (isLoading || error) ? Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : error
              ? SelectableText(errorMessage)
              : const SelectableText("Something went wrong!"),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextField(
              controller: titleController,
              focusNode: titleFocusNode,
              hintText: 'Workspace Title',
              obscureText: false,
              height: 64,
              onChanged: (text) {
                setState(() {}); // Makes the app button active or disactive
              },
            ),
            const SizedBox(height: 40.0),
            AppButton(
              isActive: titleController.text.isNotEmpty,
              text: "Create New Workspace",
              height: 50,
              onTap: () async {
                await addNewWorkspace(titleController.text);
                if (context.mounted) Navigator.of(context).pop();
                widget.onCreate();
              },
            ),
          ],
        )
    );
  }
}
