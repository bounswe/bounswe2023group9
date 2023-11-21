import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/widgets/entries_list_view.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/widgets/references_list_view.dart';
import 'package:collaborative_science_platform/screens/workspaces_page/web_workspace_page/widgets/workspaces_side_bar.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class WebWorkspacePage extends StatefulWidget {
  //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
  final int workspaceId;
  const WebWorkspacePage({super.key, this.workspaceId = 0});

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

  bool isLoading = false;
  bool showSidebar = true;
  double minHeight = 750;
//Mock data for testing purposes
  Workspace workspace = Workspace(
      workspaceId: 10,
      workspaceTitle: "My First Workspace",
      entries: [
        Entry(
            content: "ENTRY !111",
            entryDate: DateTime.now(),
            entryId: 1,
            entryNumber: 1,
            index: 0,
            isEditable: true,
            isFinalEntry: false,
            isProofEntry: false,
            isTheoremEntry: false),
        Entry(
            content: "ENTRY !111",
            entryDate: DateTime.now(),
            entryId: 1,
            entryNumber: 1,
            index: 0,
            isEditable: false,
            isFinalEntry: true,
            isProofEntry: false,
            isTheoremEntry: true),
        Entry(
            content: "ENTRY !111",
            entryDate: DateTime.now(),
            entryId: 1,
            entryNumber: 1,
            index: 0,
            isEditable: true,
            isFinalEntry: false,
            isProofEntry: true,
            isTheoremEntry: false)
      ],
      status: "workable",
      numApprovals: 0,
      contributors: [
        User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
        User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say"),
        User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
        User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say"),
        User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
        User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say")
      ],
      pendingContributors: [
        User(email: "someone@gmail.com", firstName: "collaborator", lastName: "user")
      ],
      references: [
        Node(contributors: [
          User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
          User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say")
        ], id: 99, nodeTitle: "A Node", publishDate: DateTime(2001)),
        Node(contributors: [
          User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
          User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say")
        ], id: 99, nodeTitle: "A Node", publishDate: DateTime(2001)),
        Node(contributors: [
          User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
          User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say")
        ], id: 99, nodeTitle: "A Node", publishDate: DateTime(2001)),
        Node(contributors: [
          User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
          User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say")
        ], id: 99, nodeTitle: "A Node", publishDate: DateTime(2001)),
        Node(contributors: [
          User(firstName: "omar", lastName: "uyduran", email: "oma11r@omar.com"),
          User(email: "Cem.say@cem.say", firstName: "Cem", lastName: "Say")
        ], id: 99, nodeTitle: "A Node", publishDate: DateTime(2001))
      ]);

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      /// get workspace details
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
        child: isLoading
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
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(workspace.workspaceTitle, style: TextStyles.title2),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: AppButton(
                                    text: "Send Workspace to Review",
                                    height: 45,
                                    onTap: () {},
                                    type: "primary",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              EntriesListView(
                                entries: workspace.entries,
                                controller: controller2,
                                showSidebar: showSidebar,
                                height: minHeight,
                              ),
                              Column(
                                children: [
                                  ContributorsListView(
                                    contributors: workspace.contributors,
                                    controller: controller3,
                                    height: minHeight / 2,
                                  ),
                                  ReferencesListView(
                                    references: workspace.references,
                                    controller: controller4,
                                    height: minHeight / 2,
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ));
  }
}
