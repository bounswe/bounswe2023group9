import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/responsive/responsive.dart';

class MobileWorkspacePage extends StatefulWidget {
  final int workspaceId;
  const MobileWorkspacePage({
    super.key,
    required this.workspaceId,
  });

  @override
  State<MobileWorkspacePage> createState() => _MobileWorkspacePageState();
}

class _MobileWorkspacePageState extends State<MobileWorkspacePage> {
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  Widget entryCard() {
    double height = 80.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: height,
        child: Card(
          elevation: 4.0,
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            onTap: () { /* Show the details about the entry */ },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Entry Title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget entryList(int entryCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entryCount+1,
        itemBuilder: (context, index) =>
          (index < entryCount) ? entryCard()
          : Center(
            child: IconButton(
              iconSize: 40.0,
              onPressed: () { /* Navigate to a page where new entries are created */ },
              icon: const Icon(Icons.add),
            ),
          ),
      ),
    );
  }

  Widget contributorCard() {
    double height = 60.0;
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
            onTap: () { /* Navigate to the contributors profile page */ },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Contributor Name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contributorList(int contributorCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contributorCount+1,
        itemBuilder: (context, index) =>
          (index < contributorCount) ? contributorCard()
          : Center(
            child: IconButton(
              iconSize: 40.0,
              onPressed: () { /* Navigate to a page where new contributors are added */ },
              icon: const Icon(Icons.add),
            ),
          ),
      ),
    );
  }

  Widget referenceCard() {
    double height = 60.0;
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
            onTap: () { /* Navigate to the node page of the theorem */ },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                    "Reference Theorem Title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget referenceList(int referenceCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: referenceCount+1,
        itemBuilder: (context, index) =>
          (index < referenceCount) ? referenceCard()
          : Center(
            child: IconButton(
              iconSize: 40.0,
              onPressed: () { /* Navigate to a page where new references are added */ },
              icon: const Icon(Icons.add),
            ),
          ),
      ),
    );
  }

  Widget subsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
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
        isScrollable: true,
        child: SizedBox(
          width: Responsive.getGenericPageWidth(context),
          child: ListView(
            children: [
              subsectionTitle("Entries"),
              entryList(10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(),
              ),
              subsectionTitle("Contributors"),
              contributorList(10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(),
              ),
              subsectionTitle("References"),
              referenceList(10),
            ],
          ),
        )
      );
    }
  }
}
