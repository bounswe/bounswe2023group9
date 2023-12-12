import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/reference_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/subsection_title.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../models/workspaces_page/workspace.dart';
import '../../../../utils/responsive/responsive.dart';
import '../../../../widgets/app_button.dart';
import '../../web_workspace_page/widgets/add_reference_form.dart';
import '../../web_workspace_page/widgets/entry_form.dart';
import '../../web_workspace_page/widgets/send_collaboration_request_form.dart';
import 'app_alert_dialog.dart';
import 'contributor_card.dart';
import 'entry_card.dart';

class MobileWorkspaceContent extends StatefulWidget {
  final Workspace workspace;
  final bool pending;
  final Function createNewEntry;
  final Function editEntry;
  final Function deleteEntry;
  final Function deleteReference;
  final Function addReference;
  final Function editTitle;
  final Function updateRequest;
  final Function sendCollaborationRequest;
  final Function finalizeWorkspace;
  final Function addSemanticTags;
  const MobileWorkspaceContent({
    super.key,
    required this.pending,
    required this.workspace,
    required this.createNewEntry,
    required this.editEntry,
    required this.deleteEntry,
    required this.addReference,
    required this.deleteReference,
    required this.editTitle,
    required this.addSemanticTags,
    required this.finalizeWorkspace,
    required this.sendCollaborationRequest,
    required this.updateRequest,
  });

  @override
  State<MobileWorkspaceContent> createState() => _MobileWorkspaceContentState();
}

class _MobileWorkspaceContentState extends State<MobileWorkspaceContent> {
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";
  bool entryLoading = false;

  bool titleReadOnly = true;
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  Widget addIcon(Function() onPressed) {
    return Center(
      child: IconButton(
        iconSize: 40.0,
        onPressed: onPressed,
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget firstAddition(String message, Function() onPressed) {
    return SizedBox(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          addIcon(onPressed),
        ],
      ),
    );
  }

  Widget entryList() {
    int length = widget.workspace.entries.length;
    TextEditingController contentController = TextEditingController();

    Widget alertDialog = AppAlertDialog(
      text: 'New Entry',
      content: EntryForm(newEntry: true, contentController: contentController),
      actions: [
        AppButton(
          isLoading: entryLoading,
          text: "Create New Entry",
          height: 40,
          onTap: () async {
            /* Create Entry */
            setState(() {
              entryLoading = true;
            });
            await widget.createNewEntry(contentController.text);
            setState(() {
              entryLoading = false;
            });
            contentController.text = "";
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    return widget.workspace.entries.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length + 1,
              itemBuilder: (context, index) => (index < length)
                  ? EntryCard(
                      entry: widget.workspace.entries[index],
                      onDelete: () async {
                        await widget.deleteEntry(widget.workspace.entries[index].entryId);
                      },
                      pending: widget.pending,
                      editEntry: widget.editEntry,
                    )
                  : addIcon(() {
                      showDialog(context: context, builder: (context) => alertDialog);
                    }),
            ),
          )
        : firstAddition(
            "Add Your First Entry!",
            () {
              showDialog(context: context, builder: (context) => alertDialog);
            },
          );
  }

  Widget contributorList() {
    int length = widget.workspace.contributors.length;
    Widget alertDialog = AppAlertDialog(
      text: "Send Collaboration Request",
      content:
          SendCollaborationRequestForm(sendCollaborationRequest: widget.sendCollaborationRequest),
    );

    return widget.workspace.contributors.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length + 1,
              itemBuilder: (context, index) => (index < length)
                  ? ContributorCard(contributor: widget.workspace.contributors[index])
                  : addIcon(() {
                      showDialog(context: context, builder: (context) => alertDialog);
                    }),
            ),
          )
        : firstAddition(
            "Add The First Contributor!",
            () {
              showDialog(context: context, builder: (context) => alertDialog);
            },
          );
  }

  Widget referenceList() {
    int length = widget.workspace.references.length;
    Widget alertDialog = AppAlertDialog(
      text: "Add Reference",
      content: AddReferenceForm(onAdd: widget.addReference),
    );
    return widget.workspace.references.isNotEmpty
        ? (Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length + 1,
              itemBuilder: (context, index) => (index < length)
                  ? ReferenceCard(reference: widget.workspace.references[index])
                  : addIcon(() {
                      showDialog(context: context, builder: (context) => alertDialog);
                    }),
            ),
          ))
        : firstAddition(
            "Add Your First Reference!",
            () {
              showDialog(context: context, builder: (context) => alertDialog);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || error) {
      return Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : error
                  ? SelectableText(errorMessage)
                  : const SelectableText("Something went wrong!"));
    } else {
      return SizedBox(
        width: Responsive.getGenericPageWidth(context),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0.0),
          // It needs to be nested scrollable in the future
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: titleReadOnly
                  ? [
                      Text(widget.workspace!.workspaceTitle, style: TextStyles.title2),
                      if (widget.workspace!.status == WorkspaceStatus.workable)
                        IconButton(
                            onPressed: () {
                              setState(() {
                                titleController.text = widget.workspace.workspaceTitle;
                                titleReadOnly = false;
                              });
                            },
                            icon: const Icon(Icons.edit)),
                    ]
                  : [
                      SizedBox(
                        width: 300,
                        height: 80,
                        child: AppTextField(
                            controller: titleController,
                            focusNode: titleFocusNode,
                            hintText: "",
                            obscureText: false,
                            height: 200),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: IconButton(
                            onPressed: () {
                              widget.editTitle(titleController.text);
                              widget.workspace.workspaceTitle = titleController.text;
                              setState(() {
                                titleReadOnly = true;
                              });
                            },
                            icon: const Icon(Icons.save)),
                      )
                    ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Divider(),
            ),
            const SubSectionTitle(title: "Entries"),
            entryList(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Divider(),
            ),
            const SubSectionTitle(title: "Contributors"),
            contributorList(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Divider(),
            ),
            const SubSectionTitle(title: "References"),
            referenceList(),
            const SizedBox(height: 20.0),
          ],
        ),
      );
    }
  }
}
