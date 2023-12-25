import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/create_workspace_form.dart';
import 'package:collaborative_science_platform/screens/workspace_page/workspaces_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspacesSideBar extends StatefulWidget {
  final ScrollController controller;
  final Function? hideSidebar;
  final double height;
  final Workspaces? workspaces;
  final Function createNewWorkspace;
  final Function updateReviewRequest;
  final Function updateCollaborationRequest;

  const WorkspacesSideBar({
    super.key,
    required this.controller,
    this.hideSidebar,
    required this.height,
    this.workspaces,
    required this.createNewWorkspace,
    required this.updateReviewRequest,
    required this.updateCollaborationRequest,
  });

  @override
  State<WorkspacesSideBar> createState() => _WorkspacesSideBarState();
}

class _WorkspacesSideBarState extends State<WorkspacesSideBar> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Container(
        height: widget.height + 100,
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Workspaces", style: TextStyles.title4secondary),
                    AppBarButton(
                      onPressed: () {
                        widget.hideSidebar!();
                      },
                      icon: CupertinoIcons.back,
                      text: "hide workspaces",
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: AppButton(
                        text: (MediaQuery.of(context).size.width < Responsive.desktopPageWidth)
                            ? "New"
                            : "New Workspace",
                        height: 40,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const SizedBox(
                                      width: 500,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('New Workspace', style: TextStyle(fontSize: 20.0)),
                                        ],
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    content: CreateWorkspaceForm(titleController: textController),
                                    actions: [
                                      AppButton(
                                          text: "Create New Workspace",
                                          height: 50,
                                          onTap: () async {
                                            await widget.createNewWorkspace(textController.text);
                                            textController.text = "";
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          })
                                    ],
                                  ));
                        },
                        type: "outlined",
                      )),
                ),
                SizedBox(
                  height: (widget.workspaces != null)
                      ? (auth.basicUser!.userType != "reviewer"
                          ? widget.height * 0.9
                          : widget.height * 0.40)
                      : 40,
                  child: (widget.workspaces != null)
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: (widget.workspaces!.workspaces.length +
                              widget.workspaces!.pendingWorkspaces.length),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < widget.workspaces!.workspaces.length) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: CardContainer(
                                  onTap: () {
                                    context.push(
                                        "${WorkspacesPage.routeName}/${widget.workspaces!.workspaces[index].workspaceId}");
                                    widget.hideSidebar!();
                                  },
                                  child: Text(
                                    widget.workspaces!.workspaces[index].workspaceTitle,
                                    style: TextStyles.title4,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              );
                            } else if (index >= widget.workspaces!.workspaces.length) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: CardContainer(
                                  onTap: () {
                                    context.push(
                                        "${WorkspacesPage.routeName}/${widget.workspaces!.pendingWorkspaces[index - widget.workspaces!.workspaces.length].workspaceId}");
                                    widget.hideSidebar!();
                                  },
                                  child: (MediaQuery.of(context).size.width >
                                          Responsive.desktopPageWidth)
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 7,
                                              child: Text(
                                              widget
                                                  .workspaces!
                                                  .pendingWorkspaces[
                                                      index - widget.workspaces!.workspaces.length]
                                                  .workspaceTitle,
                                              style: TextStyles.bodyBold,
                                                maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                            ),
                                            ),
                                            Column(children: [
                                              IconButton(
                                                icon: const Icon(CupertinoIcons.check_mark_circled,
                                                    color: AppColors.infoColor),
                                                onPressed: () async {
                                                  // function to accept review request
                                                  await widget.updateCollaborationRequest(
                                                      widget
                                                          .workspaces!
                                                          .pendingWorkspaces[index -
                                                              widget.workspaces!.workspaces.length]
                                                          .requestId,
                                                      RequestStatus.approved);
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  CupertinoIcons.clear_circled,
                                                  color: AppColors.warningColor,
                                                ),
                                                onPressed: () async {
                                                  // function to reject review request
                                                  await widget.updateCollaborationRequest(
                                                      widget
                                                          .workspaces!
                                                          .pendingWorkspaces[index -
                                                              widget.workspaces!.workspaces.length]
                                                          .requestId,
                                                      RequestStatus.rejected);
                                                },
                                              ),
                                            ])
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child:
                                            Text(
                                              widget
                                                  .workspaces!
                                                  .pendingWorkspaces[
                                                      index - widget.workspaces!.workspaces.length]
                                                  .workspaceTitle,
                                              style: TextStyles.bodyBold,
                                                maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      CupertinoIcons.check_mark_circled,
                                                      color: AppColors.infoColor),
                                                  onPressed: () {
                                                    // function to accept review request
                                                    widget.updateCollaborationRequest(
                                                        widget
                                                            .workspaces!
                                                            .pendingWorkspaces[index -
                                                                widget
                                                                    .workspaces!.workspaces.length]
                                                            .requestId,
                                                        RequestStatus.approved);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons.clear_circled,
                                                    color: AppColors.warningColor,
                                                  ),
                                                  onPressed: () async {
                                                    // function to reject review request
                                                    await widget.updateCollaborationRequest(
                                                        widget
                                                            .workspaces!
                                                            .pendingWorkspaces[index -
                                                                widget
                                                                    .workspaces!.workspaces.length]
                                                            .requestId,
                                                        RequestStatus.rejected);
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          })
                      : const CircularProgressIndicator(),
                ),
                if (auth.basicUser!.userType == "reviewer")
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text("Review Workspaces", style: TextStyles.title4secondary),
                  ),
                if (auth.basicUser!.userType == "reviewer")
                  SizedBox(
                    height: (widget.workspaces != null) ? widget.height * 0.40 : 40,
                    child: (widget.workspaces != null)
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: (widget.workspaces!.reviewWorkspaces.length +
                                widget.workspaces!.pendingReviewWorkspaces.length),
                            itemBuilder: (BuildContext context, int index) {
                              if (index < widget.workspaces!.reviewWorkspaces.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CardContainer(
                                    onTap: () {
                                      context.push(
                                          "${WorkspacesPage.routeName}/${widget.workspaces!.reviewWorkspaces[index].workspaceId}");
                                      widget.hideSidebar!();
                                    },
                                    child: Text(
                                      widget.workspaces!.reviewWorkspaces[index].workspaceTitle,
                                      style: TextStyles.title4,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              } else if (index >= widget.workspaces!.reviewWorkspaces.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CardContainer(
                                    onTap: () {
                                      context.push(
                                          "${WorkspacesPage.routeName}/${widget.workspaces!.pendingReviewWorkspaces[index - widget.workspaces!.reviewWorkspaces.length].workspaceId}");
                                      widget.hideSidebar!();
                                    },
                                    child: (MediaQuery.of(context).size.width >
                                            Responsive.desktopPageWidth)
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                widget
                                                    .workspaces!
                                                    .pendingReviewWorkspaces[index -
                                                        widget.workspaces!.reviewWorkspaces.length]
                                                    .workspaceTitle,
                                                style: TextStyles.bodyBold,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                              Column(children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      CupertinoIcons.check_mark_circled,
                                                      color: AppColors.infoColor),
                                                  onPressed: () async {
                                                    // function to accept review request
                                                    await widget.updateReviewRequest(
                                                        widget
                                                            .workspaces!
                                                            .pendingReviewWorkspaces[index -
                                                                widget.workspaces!.reviewWorkspaces
                                                                    .length]
                                                            .requestId,
                                                        RequestStatus.approved);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons.clear_circled,
                                                    color: AppColors.warningColor,
                                                  ),
                                                  onPressed: () async {
                                                    // function to reject review request
                                                    await widget.updateReviewRequest(
                                                        widget
                                                            .workspaces!
                                                            .pendingReviewWorkspaces[index -
                                                                widget.workspaces!.reviewWorkspaces
                                                                    .length]
                                                            .requestId,
                                                        RequestStatus.rejected);
                                                  },
                                                ),
                                              ])
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Text(
                                                widget
                                                    .workspaces!
                                                    .pendingReviewWorkspaces[index -
                                                        widget.workspaces!.reviewWorkspaces.length]
                                                    .workspaceTitle,
                                                style: TextStyles.bodyBold,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        CupertinoIcons.check_mark_circled,
                                                        color: AppColors.infoColor),
                                                    onPressed: () async {
                                                      // function to accept review request
                                                      await widget.updateReviewRequest(
                                                          widget
                                                              .workspaces!
                                                              .pendingReviewWorkspaces[index -
                                                                  widget.workspaces!
                                                                      .reviewWorkspaces.length]
                                                              .requestId,
                                                          RequestStatus.approved);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      CupertinoIcons.clear_circled,
                                                      color: AppColors.warningColor,
                                                    ),
                                                    onPressed: () async {
                                                      // function to accept review request
                                                      await widget.updateReviewRequest(
                                                          widget
                                                              .workspaces!
                                                              .pendingReviewWorkspaces[index -
                                                                  widget.workspaces!
                                                                      .reviewWorkspaces.length]
                                                              .requestId,
                                                          RequestStatus.rejected);
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            })
                        : const CircularProgressIndicator(),
                  )
              ],
            )));
  }
}
