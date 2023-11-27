import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/reference_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/subsection_title.dart';
import 'package:collaborative_science_platform/screens/workspace_page/workspaces_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../exceptions/workspace_exceptions.dart';
import '../../../../models/node.dart';
import '../../../../models/user.dart';
import '../../../../models/workspaces_page/entry.dart';
import '../../../../models/workspaces_page/workspace.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/workspace_provider.dart';
import '../../../../utils/responsive/responsive.dart';
import '../../../../widgets/app_button.dart';
import '../../web_workspace_page/widgets/add_reference_form.dart';
import '../../web_workspace_page/widgets/entry_form.dart';
import '../../web_workspace_page/widgets/send_collaboration_request_form.dart';
import 'app_alert_dialog.dart';
import 'contributor_card.dart';
import 'entry_card.dart';

class MobileWorkspaceContent extends StatefulWidget {
  final int workspaceId;
  final bool pending;
  const MobileWorkspaceContent({
    super.key,
    required this.workspaceId,
    required this.pending,
  });

  @override
  State<MobileWorkspaceContent> createState() => _MobileWorkspaceContentState();
}

class _MobileWorkspaceContentState extends State<MobileWorkspaceContent> {
  bool _isFirstTime = true;
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  Workspace workspaceData = Workspace(
    workspaceId: 0,
    workspaceTitle: "workspaceTitle",
    entries: <Entry>[],
    status: WorkspaceStatus.workable,
    numApprovals: 0,
    contributors: <User>[],
    pendingContributors: <User>[],
    references: <Node>[],
  );

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getWorkspaceData();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  Future<void> getWorkspaceData() async {
    try {
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await workspaceProvider.getWorkspaceById(widget.workspaceId, "token");
      workspaceData = workspaceProvider.workspace ?? {} as Workspace;
    } catch (e) {
      error = true;
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    return ListView(
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
    );
  }

  Widget entryList() {
    int length = workspaceData.entries.length;
    Widget alertDialog = AppAlertDialog(
      text: 'New Entry',
      content: EntryForm(
        onCreate: () {
          context.go("${WorkspacesPage.routeName}/${widget.workspaceId}");
        },
        newEntry: true,
        workspaceId: widget.workspaceId,
        content: "",
      ),

    );

    return workspaceData.entries.isNotEmpty
      ? Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: length + 1,
          itemBuilder: (context, index) => (index < length)
            ? EntryCard(
              entry: workspaceData.entries[index],
              onDelete: () {
                setState(() {
                  workspaceData.entries.removeAt(index);
                });
              },
              pending: widget.pending,
            ) : addIcon(() {
              showDialog(
                context: context,
                builder: (context) => alertDialog
              );
            }),
          ),
        ) : firstAddition(
          "Add Your First Entry!",
          () {
            showDialog(
              context: context,
              builder: (context) => alertDialog
            );
          },
    );
  }

  Widget contributorList() {
    int length = workspaceData.contributors.length;
    Widget alertDialog =  const AppAlertDialog(
      text: "Send Collaboration Request",
      content: SendCollaborationRequestForm(),
    );

    return workspaceData.contributors.isNotEmpty
        ? Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ListView.builder(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: length + 1,
            itemBuilder: (context, index) => (index < length)
              ? ContributorCard(contributor: workspaceData.contributors[index])
              : addIcon(() {
                showDialog(
                  context: context,
                  builder: (context) => alertDialog
                );
              }
            ),
            ),
          ) : firstAddition(
          "Add The First Contributor!",
          () {
            showDialog(
              context: context,
              builder: (context) => alertDialog
            );
          },
    );
  }

  Future<void> deleteReference(int nodeId) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await workspaceProvider.deleteReference(workspaceData.workspaceId, nodeId, auth.token);
    } on DeleteReferenceException {
      setState(() {
        error = true;
        errorMessage = DeleteReferenceException().message;
      });
    } catch (e) {
      error = true;
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget referenceList() {
    int length = workspaceData.references.length;
    print(widget.workspaceId.toString());
    Widget alertDialog = AppAlertDialog
      (text: "Add Reference",
      content: AddReferenceForm(workspaceId: widget.workspaceId),
    );

    return (workspaceData.references.isNotEmpty)
        ? Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ListView.builder(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: length + 1,
            itemBuilder: (context, index) => (index < length)
              ? ReferenceCard(
              reference: workspaceData.references[index],
              onDelete: () async {
                await deleteReference(workspaceData.references[index].id);
              },
            )
              : addIcon(() {
                showDialog(
                  context: context,
                  builder: (context) => alertDialog
              );
            }),
            ),
          ) : firstAddition(
          "Add Your First Reference!",
          () {
            showDialog(
                context: context,
                builder: (context) => alertDialog
            );
          },
    );
  }

  Widget mobileWorkspaceCardOptions() {
    return widget.pending ? AppButton(
      text: "Evaluate the Theorem",
      height: 40.0,
      icon: const Icon(
          Icons.check,
        color: Colors.white,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AppAlertDialog(
            text: "Do you accept or reject this theorem?",
            actions: [
              AppButton(
                text: "Accept",
                height: 40,
                onTap: () {
                  /* Accept the review */
                  Navigator.of(context).pop();
                },
              ),
              AppButton(
                text: "Reject",
                height: 40,
                onTap: () {
                  /* Reject the review */
                  Navigator.of(context).pop();
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
    ) : AppButton(
      text: "Send Theorem to Review",
      height: 40.0,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AppAlertDialog(
            text: "Do you want to send it to review?",
            actions: [
              AppButton(
                text: "Send",
                height: 40,
                onTap: () {
                  /* Send to review */
                  Navigator.of(context).pop();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Created ${widget.workspaceId}");
    if (isLoading || error) {
      return Center(
          child: isLoading ? const CircularProgressIndicator()
              : error ? SelectableText(errorMessage)
              : const SelectableText("Something went wrong!")
      );
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
              child: mobileWorkspaceCardOptions(),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      );
    }
  }
}
