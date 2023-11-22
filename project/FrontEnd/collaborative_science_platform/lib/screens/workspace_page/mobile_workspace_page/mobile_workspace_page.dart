import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces_object.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/mobile_workspace_content.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import '../../home_page/widgets/home_page_appbar.dart';

class MobileWorkspacePage extends StatefulWidget {
  const MobileWorkspacePage({super.key});

  @override
  State<MobileWorkspacePage> createState() => _MobileWorkspacesPageState();
}

class _MobileWorkspacesPageState extends State<MobileWorkspacePage> {
  final CarouselController controller = CarouselController();

  Workspaces workspacesData = Workspaces(
    workspaces: <WorkspacesObject>[],
    pendingWorkspaces: <WorkspacesObject>[],
  );

  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  int yourWorkLength = 0;
  int pendingLength = 0;
  int totalLength = 0;
  int current = 1;
  int workspaceIndex = 0;

  @override
  void initState() {
    super.initState();
    getWorkspacesData();
  }

  void getWorkspacesData() {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < 4; i++) {
      workspacesData.workspaces.add(
        WorkspacesObject(
          workspaceId: i+1,
          workspaceTitle: "Workspace Title ${i+1}",
          pending: false,
        ),
      );
    }
    for (int i = 0; i < 2; i++) {
      workspacesData.pendingWorkspaces.add(
        WorkspacesObject(
          workspaceId: i+workspacesData.workspaces.length+1,
          workspaceTitle: "Pending Workspace Title ${i+1}",
          pending: true,
        ),
      );
    }
    yourWorkLength = workspacesData.workspaces.length;
    pendingLength = workspacesData.pendingWorkspaces.length;
    totalLength = yourWorkLength + pendingLength;
    setState(() {
      isLoading = false;
    });
  }

  Widget mobileAddNewWorkspaceIcon() {
    return CircleAvatar(
      radius: 24.0,
      backgroundColor: Colors.grey.shade300,
      child: IconButton(
        iconSize: 28.0,
        onPressed: () { /* Navigate to the page where new workspaces are created */ },
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget mobileWorkspaceCard(WorkspacesObject workspacesObject, bool pending) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: 80.0,
        child: Card(
          elevation: 4.0,
          shadowColor: AppColors.primaryColor,
          color: AppColors.primaryLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pending ? "Pending" : "Your Work",
                    style: TextStyle(
                      color: pending ? Colors.red.shade800
                          : Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    workspacesObject.workspaceTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                ],
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
      children: [
        CarouselSlider(
          carouselController: controller,
          items: List.generate(
            totalLength+1,
            (index) => (index == 0) ? mobileAddNewWorkspaceIcon()
            : (index <= yourWorkLength) ? mobileWorkspaceCard(
              workspacesData.workspaces[index-1],
              false,
            ) : mobileWorkspaceCard(
              workspacesData.pendingWorkspaces[index-yourWorkLength-1],
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
            color: AppColors.primaryDarkColor,
          ),
        ),
      ],
    );
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
                workspaceId: (workspaceIndex < yourWorkLength) ? workspacesData.workspaces[workspaceIndex].workspaceId
                  : workspacesData.pendingWorkspaces[workspaceIndex-yourWorkLength].workspaceId,
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
}
