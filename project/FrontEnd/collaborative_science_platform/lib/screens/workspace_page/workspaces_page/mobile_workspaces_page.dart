import 'package:collaborative_science_platform/models/workspaces_page/workspaces.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspaces_object.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/subsection_title.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../create_workspace_page/mobile_create_workspace_page.dart';
import '../../home_page/widgets/home_page_appbar.dart';
import '../mobile_workspace_page.dart';

class MobileWorkspacesPage extends StatefulWidget {
  const MobileWorkspacesPage({super.key});

  @override
  State<MobileWorkspacesPage> createState() => _MobileWorkspacesPageState();
}

class _MobileWorkspacesPageState extends State<MobileWorkspacesPage> {
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  Workspaces workspacesData = Workspaces(
    workspaces: <WorkspacesObject>[],
    pendingWorkspaces: <WorkspacesObject>[],
  );

  @override
  void initState() {
    super.initState();
    getWorkspacesData();
  }

  void getWorkspacesData() {
    setState(() {
      isLoading = true;
    });
    for (int i = 1; i < 5; i++) {
      workspacesData.workspaces.add(
        WorkspacesObject(
          workspaceId: i,
          workspaceTitle: "Workspace Title $i",
          pending: false,
        ),
      );
    }
    for (int i = 1; i < 3; i++) {
      workspacesData.pendingWorkspaces.add(
        WorkspacesObject(
          workspaceId: i,
          workspaceTitle: "Pending Workspace Title $i",
          pending: true,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget mobileWorkspaceCard(WorkspacesObject workspacesObject) {
    double height = 70.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: height,
        child: Card(
          elevation: 4.0,
          shadowColor: AppColors.primaryColor,
          color: AppColors.primaryLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2.0),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2.0),
            ),
            onTap: () {
              // Navigate to the page where the details of the workspace are listed
              context.push('${MobileWorkspacePage.routeName}/${workspacesObject.workspaceId}');
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  workspacesObject.workspaceTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget workspaceListBuilder(bool forPending) {
    int length =
        forPending ? workspacesData.pendingWorkspaces.length : workspacesData.workspaces.length;
    List<WorkspacesObject> list =
        forPending ? workspacesData.pendingWorkspaces : workspacesData.workspaces;
    return SizedBox(
      width: Responsive.getGenericPageWidth(context),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length,
        itemBuilder: (context, index) => mobileWorkspaceCard(list[index]),
      ),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryLightColor,
          onPressed: () {
            // Navigate to the page where workspaces are created
            context.push(MobileCreateWorkspacePage.routeName);
          },
          child: const Icon(Icons.add),
        ),
        child: SizedBox(
          width: Responsive.getGenericPageWidth(context),
          child: ListView(
            children: [
              const SubSectionTitle(title: "On Going Workspaces"),
              workspaceListBuilder(false),
              const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
                child: Divider(),
              ),
              const SubSectionTitle(title: "Pending Workspaces"),
              workspaceListBuilder(true),
            ],
          ),
        ),
      );
    }
  }
}
