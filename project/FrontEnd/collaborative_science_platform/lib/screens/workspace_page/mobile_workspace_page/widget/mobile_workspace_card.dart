import 'package:collaborative_science_platform/exceptions/workspace_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/workspaces_page/workspaces_object.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/workspace_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/app_button.dart';
import 'app_alert_dialog.dart';

class MobileWorkspaceCard extends StatefulWidget {
  final WorkspacesObject workspacesObject;
  final bool pending;
  const MobileWorkspaceCard({
    super.key,
    required this.workspacesObject,
    required this.pending,
  });

  @override
  State<MobileWorkspaceCard> createState() => _MobileWorkspaceCardState();
}

class _MobileWorkspaceCardState extends State<MobileWorkspaceCard> {
  final titleTextController = TextEditingController();
  final focusNode = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleTextController.text = widget.workspacesObject.workspaceTitle;
  }

  @override
  void dispose() {
    titleTextController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> changeTitle(String newTitle) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await workspaceProvider.updateWorkspaceTitle(
        widget.workspacesObject.workspaceId,
        auth.token,
        newTitle,
      );
    } on WorkspacePermissionException {
      print(WorkspacePermissionException().message);
      // Do something specific to this exception
    } on CreateWorkspaceException {
      print(CreateWorkspaceException().message);
      // Do something specific to this exception
    } catch (e) {
      // Do something else
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: 80.0,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 2.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pending ? "Pending" : "Your Work",
                        style: TextStyle(
                          color: widget.pending ? Colors.red.shade800
                              : Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        widget.workspacesObject.workspaceTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.pending) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () { // Edit the workspace name
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AppAlertDialog(
                              text: "Change the Title of the Workspace",
                              content: TextField(
                                controller: titleTextController,
                                focusNode: focusNode,
                                maxLines: 1,
                                onChanged: (text) { /* What will happen when the text changed? */ },
                                cursorColor: Colors.grey.shade700,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.secondaryDarkColor),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                              actions: [
                                AppButton(
                                  isLoading: isLoading,
                                  text: "Change",
                                  height: 40,
                                  onTap: () async {
                                    await changeTitle(titleTextController.text);
                                    if (context.mounted) Navigator.of(context).pop();
                                  },
                                ),
                                AppButton(
                                  text: "Cancel",
                                  height: 40,
                                  onTap: () { Navigator.of(context).pop(); },
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
