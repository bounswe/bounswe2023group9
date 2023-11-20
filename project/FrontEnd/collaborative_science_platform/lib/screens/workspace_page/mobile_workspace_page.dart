import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/contributor_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/entry_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/reference_card.dart';
import 'package:collaborative_science_platform/screens/workspace_page/widgets/subsection_title.dart';
import 'package:collaborative_science_platform/utils/lorem_ipsum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import '../../models/workspaces_page/entry.dart';
import '../../utils/responsive/responsive.dart';

class MobileWorkspacePage extends StatefulWidget {
  static const routeName = '/workspace';
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

  Workspace workspaceData = Workspace(
      workspaceId: 0,
      workspaceTitle: "workspaceTitle",
      entries: <Entry>[],
      status: "pending",
      numApprovals: 0,
      contributors: <User>[],
      pendingContributors: <User>[],
      references: <Node>[],
  );


  @override
  void didChangeDependencies() {
    getWorkspaceData();
    super.didChangeDependencies();
  }

  void getWorkspaceData() {
    setState(() {
      isLoading = true;
    });

    // Automatically add the user to the list of contributors
    final User selfUser = Provider.of<Auth>(context).user as User;

    workspaceData = Workspace(
      workspaceId: 0,
      workspaceTitle: "workspaceTitle",
      entries: <Entry>[
        Entry(
          content: getLongLoremIpsum(),
          entryDate: DateTime.now(),
          entryId: 1,
          entryNumber: 1,
          index: 1,
          isEditable: false,
          isFinalEntry: false,
          isProofEntry: false,
          isTheoremEntry: true,
        ),
        Entry(
          content: getLongLoremIpsum(2),
          entryDate: DateTime.now(),
          entryId: 2,
          entryNumber: 2,
          index: 2,
          isEditable: false,
          isFinalEntry: false,
          isProofEntry: true,
          isTheoremEntry: false,
        ),
        Entry(
          content: getLongLoremIpsum(3),
          entryDate: DateTime.now(),
          entryId: 2,
          entryNumber: 2,
          index: 2,
          isEditable: false,
          isFinalEntry: true,
          isProofEntry: false,
          isTheoremEntry: false,
        ),
      ],
      status: "on going",
      numApprovals: 0,
      contributors: <User>[
        selfUser,
        User(
          email: "dummy1@mail.com",
          firstName: "dummy 1",
          lastName: "jackson",
        ),
        User(
          email: "dummy2@mail.com",
          firstName: "dummy 2",
          lastName: "jackson",
        ),
      ],
      pendingContributors: <User>[
        User(
          email: "dummy3@mail.com",
          firstName: "dummy 3",
          lastName: "jackson",
        ),
      ],
      references: <Node>[
        Node(
          contributors: <User>[],
          id: 1,
          nodeTitle: "Awesome Node Title",
          publishDate: DateTime.now(),
        ),
      ],
    );
    setState(() {
      isLoading = false;
    });
  }

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

  Widget entryList() {
    int length = workspaceData.entries.length;
    return workspaceData.entries.isNotEmpty ? Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length+1,
        itemBuilder: (context, index) =>
          (index < length) ? EntryCard(entry: workspaceData.entries[index])
          : addIcon(() { /* Navigate to a page where new entries are created */ }),
      ),
    ) : firstAddition(
        "Add Your First Entry!",
        () { /* Navigate to a page where new entries are created */ },
    );
  }

  Widget contributorList() {
    int length = workspaceData.contributors.length;
    return workspaceData.contributors.isNotEmpty ? Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length+1,
        itemBuilder: (context, index) =>
          (index < length) ? ContributorCard(contributor: workspaceData.contributors[index])
          : addIcon(() => { /* Navigate to a page where new contributors are added */ }),
      ),
    ) : firstAddition(
        "Add The First Contributor!",
        () { /* Navigate to a page where new contributors are added */ },
    );
  }

  Widget referenceList() {
    int length = workspaceData.references.length;
    return (workspaceData.references.isNotEmpty) ? Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length+1,
        itemBuilder: (context, index) =>
          (index < length) ? ReferenceCard(reference: workspaceData.references[index])
          : addIcon(() => { /* Navigate to a page where new references are added */ }),
      ),
    ) : firstAddition(
        "Add Your First Reference!",
        () { /* Navigate to a page where new references are added */ },
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
          child: ListView( // It needs to be nested scrollable in the future
            children: <Widget>[
              const SubSectionTitle(title: "Entries"),
              entryList(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(),
              ),
              const SubSectionTitle(title: "Contributors"),
              contributorList(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(),
              ),
              const SubSectionTitle(title: "References"),
              referenceList(),
            ],
          ),
        )
      );
    }
  }
}
