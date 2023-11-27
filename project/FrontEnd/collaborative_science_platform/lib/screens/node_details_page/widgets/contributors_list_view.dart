import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Contributors extends StatelessWidget {
  final List<User> contributors;
  final ScrollController controller;
  const Contributors({super.key, required this.contributors, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const Text(
            "Contributors",
            style: TextStyle(
              color: AppColors.secondaryDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width:
                Responsive.isDesktop(context) ? Responsive.desktopPageWidth / 4 : double.infinity,
            //decoration: BoxDecoration(color: Colors.grey[200]),
            child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: contributors.length,
                itemBuilder: (BuildContext context, int index) {
                  // if (index == 0) {
                  //   return Padding(
                  //     padding: Responsive.isDesktop(context)
                  //         ? const EdgeInsets.all(10)
                  //         : const EdgeInsets.all(5),
                  //     child: Text(
                  //       "Contributors",
                  //       style: Responsive.isDesktop(context)
                  //           ? TextStyles.title2secondary
                  //           : TextStyles.title3secondary,
                  //       textAlign: Responsive.isDesktop(context)
                  //           ? TextAlign.center
                  //           : TextAlign.start,
                  //     ),
                  //   );
                  // } else {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: CardContainer(
                      onTap: () {
                        final String email = contributors[index].email;
                        final String encodedEmail = Uri.encodeComponent(email);
                        context.push('${ProfilePage.routeName}/$encodedEmail');
                      },
                      child: Column(
                        children: [
                          SelectableText(
                            "${contributors[index].firstName} ${contributors[index].lastName}",
                            style: TextStyles.title4,
                          ),
                          SelectableText(
                            contributors[index].email,
                            style: TextStyles.bodyGrey,
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
