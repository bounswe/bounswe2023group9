import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/new_entry.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/reference_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/semantic_tag_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/subsection_title.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:collaborative_science_platform/widgets/semantic_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/add_reference_form.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/send_collaboration_request_form.dart';
import 'app_alert_dialog.dart';
import 'contributor_card.dart';
import 'mobile_entry_card.dart';

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
  final Function sendWorkspaceToReview;
  final Function addReview;
  final Function resetWorkspace;

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
    required this.sendWorkspaceToReview,
    required this.addReview,
    required this.resetWorkspace,
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

  bool newEntryOpen = false;
  FocusNode reviewFocusNode = FocusNode();
  TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    reviewController.dispose();
    reviewFocusNode.dispose();
    super.dispose();
  }

  Widget addIcon(Function() onPressed) {
    return Center(
      child: IconButton(
        iconSize: 40.0,
        onPressed: widget.workspace.status != WorkspaceStatus.workable ? () {} : onPressed,
        icon: Icon(
          Icons.add,
          color: widget.workspace.status != WorkspaceStatus.workable
              ? Colors.grey[200]
              : Colors.grey[800],
        ),
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

  Widget semanticTagList() {
    List<SemanticTag> tags = <SemanticTag>[
      SemanticTag(
          id: "1",
          label: "Looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong Label 1",
          description:
              "Looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong Description 1"),
      SemanticTag(id: "2", label: "Label 2", description: "Description 2"),
      SemanticTag(id: "2", label: "Label 3", description: "Description 3"),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: tags.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SemanticTagCard(
            finalized: widget.workspace.status != WorkspaceStatus.workable,
            tag: tags[index],
            backgroundColor: const Color.fromARGB(255, 220, 235, 220),
            onDelete: () {/* delete the semantic tag */},
          );
        },
      ),
    );
  }

  Widget entryList() {
    int length = widget.workspace.entries.length;
    return widget.workspace.entries.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length + 1,
              itemBuilder: (context, index) {
                return (index < length)
                    ? MobileEntryCard(
                        finalized: widget.workspace.status != WorkspaceStatus.workable,
                        entry: widget.workspace.entries[index],
                        onDelete: () async {
                          await widget.deleteEntry(widget.workspace.entries[index].entryId);
                        },
                        editEntry: widget.editEntry,
                      )
                    : NewEntry(
                        onCreate: widget.createNewEntry,
                        backgroundColor: const Color.fromARGB(255, 220, 220, 240),
                        isMobile: true,
                        finalized: widget.workspace.status != WorkspaceStatus.workable,
                      );
              },
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Add Your First Entry!",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              NewEntry(
                onCreate: widget.createNewEntry,
                backgroundColor: const Color.fromARGB(255, 220, 220, 240),
                isMobile: true,
                finalized: widget.workspace.status != WorkspaceStatus.workable,
              ),
            ],
          );
  }

  Widget contributorList() {
    int length = widget.workspace.contributors.length;
    int pendingLength = widget.workspace.pendingContributors.length;

    Widget alertDialog = AppAlertDialog(
      text: "Send Collaboration Request",
      content:
          SendCollaborationRequestForm(sendCollaborationRequest: widget.sendCollaborationRequest),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length + pendingLength + 1,
        itemBuilder: (context, index) => (index < length)
            ? ContributorCard(
                contributor: widget.workspace.contributors[index],
                pending: false,
              )
            : (index < length + pendingLength)
                ? ContributorCard(
                    contributor: widget.workspace.pendingContributors[index - length],
                    pending: true,
                  )
                : addIcon(() {
                    showDialog(context: context, builder: (context) => alertDialog);
                  }),
      ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: titleReadOnly
                      ? [
                          SizedBox(
                            width: Responsive.getGenericPageWidth(context) - 150,
                            child: Text(
                              widget.workspace.workspaceTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.title2,
                            ),
                          ),
                          if (widget.workspace.status == WorkspaceStatus.workable)
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
                              icon: const Icon(Icons.save),
                            ),
                          )
                        ],
                ),
                if (widget.workspace.requestId == -1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                    child: AppButton(
                      height: 40,
                      text: widget.pending
                          ? "Accept Workspace"
                          : widget.workspace.status == WorkspaceStatus.workable
                              ? "Finalize Workspace"
                              : widget.workspace.status == WorkspaceStatus.finalized
                                  ? "Send to Review"
                                  : (widget.workspace.status == WorkspaceStatus.rejected
                                      ? "Reset Workspace"
                                      : (widget.workspace.status == WorkspaceStatus.inReview
                                          ? "In Review"
                                          : "Published")),
                      icon: widget.pending
                          ? const Icon(Icons.approval)
                          : (widget.workspace.status == WorkspaceStatus.workable
                              ? const Icon(Icons.lock)
                              : const Icon(Icons.send)),
                      onTap: widget.pending
                          ? () {
                              // accept or reject the review
                              showDialog(
                                context: context,
                                builder: (context) => AppAlertDialog(
                                  text: "Do you accept the work?",
                                  actions: [
                                    AppButton(
                                      text: "Accept",
                                      height: 40,
                                      onTap: () {
                                        /* Send to review */
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    AppButton(
                                      text: "Reject",
                                      height: 40,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AppAlertDialog(
                                  text: widget.workspace.status == WorkspaceStatus.workable
                                      ? "Do you want to finalize the workspace?"
                                      : (widget.workspace.status == WorkspaceStatus.finalized
                                          ? "Do you want to send it to review?"
                                          : "Do you want to reset the workspace?"),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: AppButton(
                                        text: "Yes",
                                        height: 40,
                                        onTap: () {
                                          if (widget.workspace.status == WorkspaceStatus.workable) {
                                            widget.finalizeWorkspace();
                                            Navigator.of(context).pop();
                                          } else if (widget.workspace.status ==
                                              WorkspaceStatus.finalized) {
                                            /* Send to review */
                                            widget.sendWorkspaceToReview();
                                            Navigator.of(context).pop();
                                          } else if (widget.workspace.status ==
                                              WorkspaceStatus.rejected) {
                                            widget.resetWorkspace();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: AppButton(
                                        text: "No",
                                        height: 40,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                    ),
                  ),
                if (widget.workspace.requestId != -1 &&
                    widget.workspace.status == WorkspaceStatus.inReview)
                  /** adjust it to check if the user is reviewer of this workspace */
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                    child: AppButton(
                      isActive: widget.workspace.status == WorkspaceStatus.inReview,
                      text: "Review Workspace",
                      height: 40,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AppAlertDialog(
                            text: "Review Workspace",
                            content: AppTextField(
                              controller: reviewController,
                              focusNode: reviewFocusNode,
                              hintText: "Your Review",
                              obscureText: false,
                              height: 200,
                              maxLines: 10,
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: AppButton(
                                  text: "Approve Workspace",
                                  height: 40,
                                  onTap: () {
                                    /** Approve workspace*/
                                    widget.addReview(widget.workspace.requestId,
                                        RequestStatus.approved, reviewController.text);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: AppButton(
                                  text: "Reject Workspace",
                                  height: 40,
                                  type: "outlined",
                                  onTap: () {
                                    /** Reject workspace*/
                                    widget.addReview(widget.workspace.requestId,
                                        RequestStatus.rejected, reviewController.text);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      type: "primary",
                    ),
                  ),
              ]),
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
            const SubSectionTitle(title: "Semantic Tags"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SemanticSearchBar(addSemanticTags: widget.addSemanticTags),
            ),
            semanticTagList(),
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
            const SizedBox(height: 100.0),
          ],
        ),
      );
    }
  }
}
