import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/entries_list_view.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/references_list_view.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/workspaces_side_bar.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:collaborative_science_platform/utils/responsive/responsive.dart';

class WebWorkspacePage extends StatefulWidget {
  final Workspace? workspace;
  final Workspaces? workspaces;
  final bool isLoading;
  final Function createNewWorkspace;
  final Function createNewEntry;
  final Function editEntry;
  final Function deleteEntry;
  final Function addReference;
  final Function deleteReference;
  final Function editTitle;

  final Function updateRequest;
  final Function sendCollaborationRequest;
  final Function finalizeWorkspace;
  final Function addSemanticTags;


  const WebWorkspacePage({
    super.key,
    required this.workspace,
    required this.workspaces,
    required this.isLoading,
    required this.createNewWorkspace,
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
  State<WebWorkspacePage> createState() => _WebWorkspacePageState();
}

class _WebWorkspacePageState extends State<WebWorkspacePage> {
  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();
  ScrollController controller3 = ScrollController();
  ScrollController controller4 = ScrollController();

  bool _isFirstTime = true;

  bool error = false;
  String errorMessage = "";

  bool showSidebar = true;
  double minHeight = 750;

  bool titleReadOnly = true;
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      _isFirstTime = false;
    }
    if (MediaQuery.of(context).size.height > 750) {
      setState(() {
        minHeight = MediaQuery.of(context).size.height;
      });
    }

    super.didChangeDependencies();
  }

  hideSideBar() {
    setState(() {
      showSidebar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
        appBar: const HomePageAppBar(),
        pageColor: Colors.grey.shade200,
        child: widget.isLoading
            ? Container(
                padding: const EdgeInsets.only(top: 32),
                decoration: const BoxDecoration(color: Colors.white),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : error
                ? Text(errorMessage, style: const TextStyle(color: Colors.red))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showSidebar)
                        WorkspacesSideBar(
                          controller: controller1,
                          hideSidebar: hideSideBar,
                          height: minHeight,
                          workspaces: widget.workspaces,
                          createNewWorkspace: widget.createNewWorkspace,
                        ),
                      if (!showSidebar)
                        Container(
                            height: minHeight + 100,
                            width: MediaQuery.of(context).size.width * 0.05,
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
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                AppBarButton(
                                  onPressed: () {
                                    setState(() {
                                      showSidebar = true;
                                    });
                                  },
                                  icon: CupertinoIcons.forward,
                                  text: "hide workspaces",
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    "Show Workspaces",
                                    textAlign: TextAlign.end,
                                    style: TextStyles.title4black,
                                  ),
                                )
                              ],
                            )),
                      if (widget.workspace != null)
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: titleReadOnly
                                        ? [
                                            Text(widget.workspace!.workspaceTitle,
                                                style: TextStyles.title2),
                                            if (widget.workspace!.status ==
                                                WorkspaceStatus.workable)
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      titleController.text =
                                                          widget.workspace!.workspaceTitle;

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
                                                    widget.workspace!.workspaceTitle =
                                                        titleController.text;
                                                    setState(() {
                                                      titleReadOnly = true;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.save)),
                                            )
                                          ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 5,
                                    child: AppButton(
                                      text: (MediaQuery.of(context).size.width > Responsive.desktopPageWidth) ? "Send Review" : "Send",
                                      height: 45,
                                      onTap: () {},
                                      type: "primary",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                EntriesListView(
                                  entries: widget.workspace!.entries,
                                  controller: controller2,
                                  showSidebar: showSidebar,
                                  height: minHeight,
                                  createNewEntry: widget.createNewEntry,
                                  editEntry: widget.editEntry,
                                  deleteEntry: widget.deleteEntry,
                                ),
                                Column(
                                  children: [
                                    ContributorsListView(
                                      contributors: widget.workspace!.contributors,
                                      pendingContributors: widget.workspace!.pendingContributors,
                                      controller: controller3,
                                      height: minHeight / 2,
                                      sendCollaborationRequest: widget.sendCollaborationRequest,
                                      updateRequest: widget.updateRequest,
                                    ),
                                    ReferencesListView(
                                      references: widget.workspace!.references,
                                      controller: controller4,
                                      height: minHeight / 2,
                                      addReference: widget.addReference,
                                      deleteReference: widget.deleteReference,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      else
                        SizedBox(
                          width: showSidebar
                              ? MediaQuery.of(context).size.width * 0.75
                              : MediaQuery.of(context).size.width * 0.95,
                          height: minHeight,
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Select a workspace to see details.",
                                  style: TextStyles.title2,
                                )
                              ]),
                        )
                    ],
                  ));
  }
}
