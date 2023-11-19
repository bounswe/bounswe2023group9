import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/contributor_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/entry_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/reference_card.dart';
import 'package:flutter/material.dart';

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

  Widget addIcon(Function() onPressed) {
    return Center(
      child: IconButton(
        iconSize: 40.0,
        onPressed: onPressed,
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget firstAddition(String message, Function() onPressed) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Center(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        addIcon(() { /* Navigate to a page where new entries are created */ }),
      ],
    );
  }

  Widget entryList(int entryCount) {
    return (entryCount != 0) ? Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entryCount+1,
        itemBuilder: (context, index) =>
          (index < entryCount) ? const EntryCard()
          : addIcon(() { /* Navigate to a page where new entries are created */ }),
      ),
    ) : firstAddition(
        "Add Your First Entry!",
        () { /* Navigate to a page where new entries are created */ },
    );
  }

  Widget contributorList(int contributorCount) {
    return (contributorCount != 0) ? Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contributorCount+1,
        itemBuilder: (context, index) =>
          (index < contributorCount) ? const ContributorCard()
          : addIcon(() => { /* Navigate to a page where new contributors are added */ }),
      ),
    ) : firstAddition(
        "Add The First Contributor!",
        () { /* Navigate to a page where new contributors are added */ },
    );
  }

  Widget referenceList(int referenceCount) {
    return (referenceCount != 0) ? Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: referenceCount+1,
        itemBuilder: (context, index) =>
          (index < referenceCount) ? const ReferenceCard()
          : addIcon(() => { /* Navigate to a page where new references are added */ }),
      ),
    ) : firstAddition(
        "Add Your First Reference!",
        () { /* Navigate to a page where new references are added */ },
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
              entryList(5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(),
              ),
              subsectionTitle("Contributors"),
              contributorList(0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(),
              ),
              subsectionTitle("References"),
              referenceList(0),
            ],
          ),
        )
      );
    }
  }
}
