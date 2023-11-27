import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/app_alert_dialog.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/mobile_workspace_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/mobile_workspace_content.dart';
import 'package:collaborative_science_platform/screens/workspace_page/web_workspace_page/widgets/create_workspace_form.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import '../../home_page/widgets/home_page_appbar.dart';

class MobileWorkspacePage extends StatefulWidget {
  final Workspace? workspace;
  final Workspaces? workspaces;
  const MobileWorkspacePage({
    super.key,
    required this.workspace,
    required this.workspaces,
  });

  @override
  State<MobileWorkspacePage> createState() => _MobileWorkspacesPageState();
}

class _MobileWorkspacesPageState extends State<MobileWorkspacePage> {
  final CarouselController controller = CarouselController();

  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  int yourWorkLength = 0;
  int pendingLength = 0;
  int totalLength = 0;
  int current = 1;
  int workspaceIndex = 0;

  @override
  void didChangeDependencies() {
    yourWorkLength = widget.workspaces!.workspaces.length;
    pendingLength = widget.workspaces!.pendingWorkspaces.length;
    totalLength = yourWorkLength + pendingLength;
    super.didChangeDependencies();
  }

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
                onCreate: () {
                  // Refresh the page
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget slidingWorkspaceList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider(
          carouselController: controller,
          items: List.generate(
            totalLength+1,
            (index) => (index == 0) ? mobileAddNewWorkspaceIcon()
            : (index <= yourWorkLength) ? MobileWorkspaceCard(
                workspacesObject: widget.workspaces!.workspaces[index-1],
                pending: false
            ) : MobileWorkspaceCard(
              workspacesObject: widget.workspaces!.pendingWorkspaces[index-yourWorkLength-1],
              pending: true,
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
              // I added this conditional to reduce the number
              // of build operation for the workspace.
              // Going to slide 1 from slide 2 or vice versa does not affect the
              // workspace content below. So it shouldn't be reloaded again.
              // However, it doesn't work. One that solves this problem wins a chukulat.
              if (index != 0 && current != 0) {
                setState(() {
                  workspaceIndex = index-1;
                });
              }
              setState(() {
                current = index;
              });
            },
          ),
        ),
        Text(
          "${current+1}/${totalLength+1}",
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading || error) ? AppCircularProgressIndicator(
        isLoading: isLoading,
        error: error,
        errorMessage: errorMessage,
    ) : PageWithAppBar(
        appBar: const HomePageAppBar(),
        child: SizedBox(
          width: Responsive.getGenericPageWidth(context),
          child: ListView(
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.only(top: 10.0),
            children: [
              slidingWorkspaceList(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(),
              ),
              (totalLength != 0) ? MobileWorkspaceContent(
                workspaceId: (workspaceIndex < yourWorkLength) ? widget.workspaces!.workspaces[workspaceIndex].workspaceId
                  : widget.workspaces!.pendingWorkspaces[workspaceIndex-yourWorkLength].workspaceId,
                pending: (workspaceIndex < yourWorkLength) ? false : true,
              ) : const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 0.0),
                child: Text(
                  "You haven't created any workspace yet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
}
