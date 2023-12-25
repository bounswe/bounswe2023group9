import 'package:collaborative_science_platform/extensions/string_extensions.dart';
import 'package:collaborative_science_platform/helpers/select_buttons_helper.dart';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Contributors extends StatelessWidget {
  final List<User> contributors;
  final List<SemanticTag> semanticTags;
  final ScrollController controller;
  const Contributors(
      {super.key,
      required this.contributors,
      required this.semanticTags,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: Responsive.isDesktop(context) ? Responsive.desktopPageWidth / 4 : double.infinity,
        //decoration: BoxDecoration(color: Colors.grey[200]),
        child: ListView.builder(
            //controller: controller,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: contributors.length + semanticTags.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Center(
                    child: Text(
                      "Contributors",
                      style: TextStyle(
                        color: AppColors.secondaryDarkColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              if (index < contributors.length + 1) {
                return ContributerView(contributor: contributors[index - 1]);
              } else if (index == contributors.length + 1 && semanticTags.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Center(
                    child: Text(
                      "Semantic Tags",
                      style: TextStyle(
                        color: AppColors.secondaryDarkColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else if (index > contributors.length + 1) {
                return SemanticTagBox(semanticTag: semanticTags[index - contributors.length - 2]);
              }
              return const SizedBox();
            }),
      ),
    );
  }
}

class ContributerView extends StatelessWidget {
  const ContributerView({
    super.key,
    required this.contributor,
  });

  final User contributor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: CardContainer(
        onTap: () {
          final String email = contributor.email;
          final String encodedEmail = Uri.encodeComponent(email);
          context.push('${ProfilePage.routeName}/$encodedEmail');
        },
        child: Column(
          children: [
            SelectableText(
              "${contributor.firstName} ${contributor.lastName}",
              style: TextStyles.title4,
            ),
            SelectableText(
              contributor.email,
              style: TextStyles.bodyGrey,
            )
          ],
        ),
      ),
    );
  }
}

class SemantigTagsListView extends StatelessWidget {
  final List<SemanticTag> semanticTags;
  final ScrollController controller;
  const SemantigTagsListView({super.key, required this.semanticTags, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: Responsive.isDesktop(context) ? Responsive.desktopPageWidth / 4 : double.infinity,
        //decoration: BoxDecoration(color: Colors.grey[200]),
        child: ListView.builder(
            //controller: controller,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: semanticTags.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Center(
                    child: Text(
                      "Semantig Tags",
                      style: TextStyle(
                        color: AppColors.secondaryDarkColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return SemanticTagBox(semanticTag: semanticTags[index - 1]);
            }),
      ),
    );
  }
}

class SemanticTagBox extends StatelessWidget {
  const SemanticTagBox({
    super.key,
    required this.semanticTag,
  });

  final SemanticTag semanticTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: CardContainer(
        onTap: () async {
          await Provider.of<NodeProvider>(context, listen: false)
              .search(SearchType.both, semanticTag.wid, semantic: true);
          SelectButtonsHelper.selectedIndex = -1;
          context.go('/');
        },
        child: Column(
          children: [
            SelectableText(
              semanticTag.label.capitalize(),
              style: TextStyles.title4,
            ),
          ],
        ),
      ),
    );
  }
}
