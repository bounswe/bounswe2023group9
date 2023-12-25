import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces_object.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/mobile_workspace_content.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/comments_sidebar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/create_workspace_form.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/workspaces_side_bar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/workspaces_page.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';

class MobileWorkspacePage extends StatefulWidget {
  final Workspace? workspace;
  final Workspaces? workspaces;
  final Function createNewWorkspace;
  final Function createNewEntry;
  final Function editEntry;
  final Function deleteEntry;
  final Function addReference;
  final Function deleteReference;
  final Function editTitle;
  final Function sendCollaborationRequest;
  final Function finalizeWorkspace;
  final Function addSemanticTags;
  final Function sendWorkspaceToReview;
  final Function addReview;
  final Function updateReviewRequest;
  final Function updateCollaborationRequest;

  const MobileWorkspacePage({
    super.key,
    required this.workspace,
    required this.workspaces,
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
    required this.sendWorkspaceToReview,
    required this.addReview,
    required this.updateReviewRequest,
    required this.updateCollaborationRequest,
  });

  @override
  State<MobileWorkspacePage> createState() => _MobileWorkspacesPageState();
}

class _MobileWorkspacesPageState extends State<MobileWorkspacePage> {
  final CarouselController controller = CarouselController();
  TextEditingController textController = TextEditingController();
  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();

  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  int current = 1;
  int workspaceIndex = 0;

  bool showSidebar = false;
  bool showCommentSidebar = false;

  Widget mobileAddNewWorkspaceIcon() {
    return CircleAvatar(
      radius: 24.0,
      backgroundColor: Colors.grey.shade300,
      child: IconButton(
        iconSize: 28.0,
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AppAlertDialog(
              text: "Create Workspace",
              content: CreateWorkspaceForm(
                titleController: textController,
              ),
              actions: [
                AppButton(
                  text: "Create New Workspace",
                  height: 50,
                  onTap: () async {
                    await widget.createNewWorkspace(textController.text);
                    textController.text = "";
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget mobileWorkspaceCard(WorkspacesObject workspacesObject, bool pending) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: 80.0,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onTap: () {
              context.push("${WorkspacesPage.routeName}/${workspacesObject.workspaceId}");
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 2.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pending ? "Pending" : "Your Work",
                            style: TextStyle(
                              color: pending ? Colors.red.shade800 : Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            workspacesObject.workspaceTitle,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget slidingWorkspaceList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.workspaces != null
          ? [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 110,
                child: CarouselSlider(
                  carouselController: controller,
                  items: List.generate(
                    widget.workspaces!.workspaces.length +
                        widget.workspaces!.pendingWorkspaces.length +
                        1,
                    (index) => (index == 0)
                        ? mobileAddNewWorkspaceIcon()
                        : (index <= widget.workspaces!.workspaces.length)
                            ? mobileWorkspaceCard(
                                widget.workspaces!.workspaces[index - 1],
                                false,
                              )
                            : mobileWorkspaceCard(
                                widget.workspaces!.pendingWorkspaces[
                                    index - widget.workspaces!.workspaces.length - 1],
                                true,
                              ),
                  ),
                  options: CarouselOptions(
                    scrollPhysics: const ScrollPhysics(),
                    height: 100,
                    autoPlay: false,
                    viewportFraction: 0.8,
                    enableInfiniteScroll: false,
                    initialPage: current,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    enlargeFactor: 0.3,
                    onPageChanged: (index, reason) {
                      if (index != 0 && current != 0) {
                        setState(() {
                          workspaceIndex = index - 1;
                        });
                      }
                      setState(() {
                        current = index;
                      });
                    },
                  ),
                ),
              ),
              Text(
                "${current + 1}/${widget.workspaces!.workspaces.length + widget.workspaces!.pendingWorkspaces.length + 1}",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
          : [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                //child: mobileAddNewWorkspaceIcon(),
              )
            ],
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  hideSideBar() {
    setState(() {
      showSidebar = false;
    });
  }

  hideCommentsSideBar() {
    setState(() {
      showCommentSidebar = false;
    });
  }

  displayCommentSidebar() {
    setState(() {
      showCommentSidebar = true;
      showSidebar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || error) {
      return PageWithAppBar(
        appBar: const HomePageAppBar(),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : error
                  ? SelectableText(errorMessage)
                  : const SelectableText("Something went wrong!"),
        ),
      );
    } else {
      return PageWithAppBar(
        appBar: const HomePageAppBar(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: Responsive.getGenericPageWidth(context),
          child: ListView(
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.only(top: 10.0),
            children: showSidebar || showCommentSidebar
                ? [
                    if (showSidebar && !showCommentSidebar)
                      WorkspacesSideBar(
                        controller: controller1,
                        hideSidebar: hideSideBar,
                        height: MediaQuery.of(context).size.height,
                        workspaces: widget.workspaces,
                        createNewWorkspace: widget.createNewWorkspace,
                        updateReviewRequest: widget.updateReviewRequest,
                        updateCollaborationRequest: widget.updateCollaborationRequest,
                      ),
                    if (showCommentSidebar && !showSidebar)
                      CommentsSideBar(
                        controller: controller2,
                        height: MediaQuery.of(context).size.height,
                        comments: widget.workspace!.comments,
                        hideSidebar: hideCommentsSideBar,
                      )
                  ]
                : [
                    // slidingWorkspaceList(),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 12.0),
                    //   child: Divider(),
                    // ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: AppBarButton(
                          onPressed: () {
                            setState(() {
                              showSidebar = true;
                              showCommentSidebar = false;
                            });
                          },
                          icon: Icons.menu,
                          text: "hide workspaces",
                        ),
                      ),
                      const Text(
                        "Workspaces",
                        style: TextStyles.bodyGrey,
                      )
                    ]),
                    (widget.workspaces != null && widget.workspace == null)
                        ? ((widget.workspaces!.workspaces.length +
                                    widget.workspaces!.pendingWorkspaces.length !=
                                0)
                            ? const Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 0.0),
                                child: Text(
                                  "Select a workspace to see details.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24.0,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 0.0),
                                child: Text(
                                  "You haven't created any workspace yet!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ))
                        : (widget.workspaces != null && widget.workspace != null)
                            ? MobileWorkspaceContent(
                                workspace: widget.workspace!,
                                pending: (workspaceIndex < widget.workspaces!.workspaces.length)
                                    ? false
                                    : true,
                                createNewEntry: widget.createNewEntry,
                                editEntry: widget.editEntry,
                                deleteEntry: widget.deleteEntry,
                                addReference: widget.addReference,
                                deleteReference: widget.deleteReference,
                                editTitle: widget.editTitle,
                                addSemanticTags: widget.addSemanticTags,
                                finalizeWorkspace: widget.finalizeWorkspace,
                                sendCollaborationRequest: widget.sendCollaborationRequest,
                                updateRequest: widget.updateCollaborationRequest,
                                sendWorkspaceToReview: widget.sendWorkspaceToReview,
                                addReview: widget.addReview,
                                displayCommentSidebar: displayCommentSidebar,
                              )
                            : const SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                  ],
          ),
        ),
      );
    }
  }
}
