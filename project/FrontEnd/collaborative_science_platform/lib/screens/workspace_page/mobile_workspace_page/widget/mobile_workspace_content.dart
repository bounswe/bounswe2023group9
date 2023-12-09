import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/reference_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/subsection_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/node.dart';
import '../../../../models/user.dart';
import '../../../../models/workspaces_page/entry.dart';
import '../../../../models/workspaces_page/workspace.dart';
import '../../../../providers/auth.dart';
import '../../../../utils/lorem_ipsum.dart';
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
  const MobileWorkspaceContent({
    super.key,
    required this.pending,
    required this.workspace,
  });

  @override
  State<MobileWorkspaceContent> createState() => _MobileWorkspaceContentState();
}

class _MobileWorkspaceContentState extends State<MobileWorkspaceContent> {
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  // Workspace workspaceData = Workspace(
  //   workspaceId: 0,
  //   workspaceTitle: "workspaceTitle",
  //   entries: <Entry>[],
  //   status: WorkspaceStatus.workable,
  //   numApprovals: 0,
  //   contributors: <User>[],
  //   pendingContributors: <User>[],
  //   references: <Node>[],
  // );

  @override
  void didChangeDependencies() {
    //getWorkspaceData();
    super.didChangeDependencies();
  }

  // void getWorkspaceData() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   workspaceData = Workspace(
  //     workspaceId: 0,
  //     workspaceTitle: "workspaceTitle",
  //     entries: <Entry>[
  //       Entry(
  //         content: getLongLoremIpsum(),
  //         entryDate: DateTime.now(),
  //         entryId: 1,
  //         entryNumber: 1,
  //         index: 1,
  //         isEditable: false,
  //         isFinalEntry: false,
  //         isProofEntry: false,
  //         isTheoremEntry: true,
  //       ),
  //       Entry(
  //         content: getLongLoremIpsum(2),
  //         entryDate: DateTime.now(),
  //         entryId: 2,
  //         entryNumber: 2,
  //         index: 2,
  //         isEditable: false,
  //         isFinalEntry: false,
  //         isProofEntry: true,
  //         isTheoremEntry: false,
  //       ),
  //       Entry(
  //         content: getLongLoremIpsum(3),
  //         entryDate: DateTime.now(),
  //         entryId: 2,
  //         entryNumber: 2,
  //         index: 2,
  //         isEditable: false,
  //         isFinalEntry: true,
  //         isProofEntry: true,
  //         isTheoremEntry: false,
  //       ),
  //     ],
  //     status: WorkspaceStatus.workable,
  //     numApprovals: 0,
  //     contributors: <User>[
  //       // Automatically add the user to the list of contributors
  //       // It will be deleted once the providers are implemented
  //       if (!widget.pending) Provider.of<Auth>(context).user as User,
  //       User(
  //         email: "dummy1@mail.com",
  //         firstName: "dummy 1",
  //         lastName: "jackson",
  //       ),
  //       User(
  //         email: "dummy2@mail.com",
  //         firstName: "dummy 2",
  //         lastName: "jackson",
  //       ),
  //     ],
  //     pendingContributors: <User>[
  //       User(
  //         email: "dummy3@mail.com",
  //         firstName: "dummy 3",
  //         lastName: "jackson",
  //       ),
  //     ],
  //     references: <Node>[
  //       Node(
  //         contributors: <User>[
  //           User(
  //             email: "dummy1@mail.com",
  //             firstName: "dummy 1",
  //             lastName: "jackson",
  //           ),
  //           User(
  //             email: "dummy2@mail.com",
  //             firstName: "dummy 2",
  //             lastName: "jackson",
  //           ),
  //         ],
  //         id: 1,
  //         nodeTitle: "Awesome Node Title",
  //         publishDate: DateTime.now(),
  //       ),
  //     ],
  //   );
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

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
    Widget alertDialog = AppAlertDialog(
      text: 'New Entry',
      content: const EntryForm(newEntry: true),
      actions: [
        AppButton(
          text: "Create New Entry",
          height: 40,
          onTap: () {
            /* Create Entry */
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
                      onDelete: () {
                        setState(() {
                          widget.workspace.entries.removeAt(index);
                        });
                      },
                      pending: widget.pending,
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
    Widget alertDialog = const AppAlertDialog(
      text: "Send Collaboration Request",
      content: SendCollaborationRequestForm(),
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
    Widget alertDialog = const AppAlertDialog(
      text: "Add Reference",
      content: AddReferenceForm(),
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
                showDialog(
                  context: context,
                  builder: (context) => alertDialog
              );
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
            const SizedBox(height: 10.0),
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
