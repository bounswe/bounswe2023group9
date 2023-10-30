import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/textStyles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class Contributors extends StatelessWidget {
  final List<User> contributors;
  final ScrollController controller;
  const Contributors(
      {super.key, required this.contributors, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isDesktop(context) ? 300 : double.infinity,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: contributors.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: Responsive.isDesktop(context)
                    ? const EdgeInsets.all(10)
                    : const EdgeInsets.all(5),
                child: Text(
                  "Contributors",
                  style: Responsive.isDesktop(context)
                      ? TextStyles.title2secondary
                      : TextStyles.title3secondary,
                  textAlign: Responsive.isDesktop(context)
                      ? TextAlign.center
                      : TextAlign.start,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: CardContainer(
                  child: Column(
                    children: [
                      Text(
                        "${contributors[index - 1].firstName} ${contributors[index - 1].lastName}",
                        style: TextStyles.title4,
                      ),
                      Text(
                        contributors[index - 1].email,
                        style: TextStyles.bodyGrey,
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}