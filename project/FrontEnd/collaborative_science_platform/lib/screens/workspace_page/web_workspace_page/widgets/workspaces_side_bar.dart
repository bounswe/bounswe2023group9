import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
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

class WorkspacesSideBar extends StatefulWidget {
  final ScrollController controller;
  final Function? hideSidebar;
  final double height;
  final Workspaces? workspaces;

  const WorkspacesSideBar(
      {super.key,
      required this.controller,
      this.hideSidebar,
      required this.height,
      this.workspaces});

  @override
  State<WorkspacesSideBar> createState() => _WorkspacesSideBarState();
}

class _WorkspacesSideBarState extends State<WorkspacesSideBar> {

  Widget pendingWorkspaceCardContent(int index) {
    Widget pendingAcceptIconButton = IconButton(
      icon: const Icon(
        CupertinoIcons.check_mark_circled,
        color: AppColors.infoColor,
      ),
      onPressed: () {}, // function to accept collaboration request
    );
    Widget pendingRejectIconButton = IconButton(
      icon: const Icon(
        CupertinoIcons.clear_circled,
        color: AppColors.warningColor,
      ),
      onPressed: () {}, // function to reject collaboration request
    );
    Widget pendingWorkspaceName = Text(
      widget.workspaces!
          .pendingWorkspaces[index - widget.workspaces!.workspaces.length]
          .workspaceTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.title4,
      textAlign: TextAlign.start,
    );

    return (MediaQuery.of(context).size.width >= Responsive.desktopPageWidth) ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        pendingWorkspaceName,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pendingAcceptIconButton,
            pendingRejectIconButton,
          ],
        ),
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pendingWorkspaceName,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            pendingAcceptIconButton,
            pendingRejectIconButton,
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      "Workspaces",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (MediaQuery.of(context).size.width < Responsive.desktopPageWidth) ? TextStyles.title4secondary : TextStyles.title3secondary,
                    ),
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
                        text: (MediaQuery.of(context).size.width < Responsive.desktopPageWidth) ? "Create" : "Create Workspace",
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
                                          Text('Create New Workspace', style: TextStyle(fontSize: 20.0)),
                                        ],
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    content: const CreateWorkspaceForm(),
                                    actions: [
                                      AppButton(
                                          text: "Create", height: 50, onTap: () {})
                                    ],
                                  )
                          );
                        },
                        type: "outlined",
                      )
                  ),
                ),
                SizedBox(
                  height: (widget.workspaces != null) ? widget.height * 0.9 : 40,
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
                                },
                                child: Text(
                                    widget.workspaces!.workspaces[index].workspaceTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                      "${WorkspacesPage.routeName}/${widget.workspaces!.pendingWorkspaces[index - widget.workspaces!.workspaces.length].workspaceId}"
                                    );
                                  },
                                  child: pendingWorkspaceCardContent(index),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                          })
                      : const CircularProgressIndicator(),
                ),
              ],
            ),
        ),
    );
  }
}
