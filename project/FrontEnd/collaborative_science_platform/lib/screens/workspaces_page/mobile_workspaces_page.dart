import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/workspace_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home_page/widgets/home_page_appbar.dart';

class MobileWorkspacesPage extends StatefulWidget {
  const MobileWorkspacesPage({super.key});

  @override
  State<MobileWorkspacesPage> createState() => _MobileWorkspacesPageState();
}

class _MobileWorkspacesPageState extends State<MobileWorkspacesPage> {
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";
  int workspaceId = 1;

  Widget mobileWorkspaceCard(String workspaceName) {
    double height = 80.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: height,
        child: Card(
          elevation: 4.0,
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height/2.0),
          ),
          child: InkWell(
            onTap: () { // Navigate to the page where the details of the workspace are listed
              context.push('${WorkspacePage.routeName}/$workspaceId');

            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  workspaceName,
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

  Widget workspaceListBuilder(int workspaceCount) {
    return SizedBox(
      width: Responsive.getGenericPageWidth(context),
      child: ListView.builder(
        itemCount: workspaceCount+1,
        itemBuilder: (context, index) =>
            (index < workspaceCount) ? mobileWorkspaceCard("Workspace ${index+1}")
            : const SizedBox(height: 60.0), // Floating action button does not overlap with the last workspace card
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
          onPressed: () { // Navigate to the page where workspaces are created

          },
          child: const Icon(Icons.add),
        ),
        child: workspaceListBuilder(10),
      );
    }
  }
}
