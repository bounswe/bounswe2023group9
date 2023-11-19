import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces_object.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkspacesSideBar extends StatefulWidget {
  final ScrollController controller;
  final hideSidebar;
  final double height;

  const WorkspacesSideBar(
      {super.key, required this.controller, required this.hideSidebar, required this.height});

  @override
  State<WorkspacesSideBar> createState() => _WorkspacesSideBarState();
}

class _WorkspacesSideBarState extends State<WorkspacesSideBar> {
  //mock data
  Workspaces workspaces = Workspaces(workspaces: [
    WorkspacesObject(workspaceId: 1, workspaceTitle: "My First Workspace", pending: false),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "My Second Workspace", pending: false),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "Someone's Workspace", pending: true),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "My First Workspace", pending: false),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "My Second Workspace", pending: false),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "Someone's Workspace", pending: true),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "My First Workspace", pending: false),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "My Second Workspace", pending: false),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "Someone's Workspace", pending: true),
  ], pendingWorkspaces: [
    WorkspacesObject(workspaceId: 1, workspaceTitle: "Someone's Workspace", pending: true),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "Someone's Workspace", pending: true),
    WorkspacesObject(workspaceId: 1, workspaceTitle: "Someone's Workspace", pending: true),
  ]);

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
                    const Text("My Workspaces", style: TextStyles.title2secondary),
                    AppBarButton(
                      onPressed: widget.hideSidebar,
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
                        text: "Create New Workspace",
                        height: 40,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    title: SizedBox(
                                      width: 500,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('New Workspace', style: TextStyle(fontSize: 20.0)),
                                        ],
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.white,
                                    content: Placeholder(),
                                  ));
                        },
                        type: "outlined",
                      )),
                ),
                SizedBox(
                    height: widget.height * 0.9,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount:
                            (workspaces.workspaces.length + workspaces.pendingWorkspaces.length),
                        itemBuilder: (BuildContext context, int index) {
                          if (index < workspaces.workspaces.length &&
                              !workspaces.workspaces[index].pending) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: CardContainer(
                                onTap: () {},
                                child: Text(
                                  workspaces.workspaces[index].workspaceTitle,
                                  style: TextStyles.title4,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          } else if (index >= workspaces.workspaces.length) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: CardContainer(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        workspaces
                                            .pendingWorkspaces[index - workspaces.workspaces.length]
                                            .workspaceTitle,
                                        style: TextStyles.bodyBold,
                                        textAlign: TextAlign.start,
                                      ),
                                      Column(children: [
                                        IconButton(
                                          icon: const Icon(CupertinoIcons.check_mark_circled,
                                              color: AppColors.infoColor),
                                          onPressed: () {
                                            // function to accept collaboration request
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.clear_circled,
                                            color: AppColors.warningColor,
                                          ),
                                          onPressed: () {
                                            // function to reject collaboration request
                                          },
                                        ),
                                      ])
                                    ],
                                  )),
                            );
                          } else {
                            return const SizedBox();
                          }
                        })),
              ],
            )));
  }
}
