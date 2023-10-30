import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class References extends StatelessWidget {
  final List<SmallNode> references;
  const References({super.key, required this.references});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: Responsive.isDesktop(context) ? references.length : references.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (Responsive.isDesktop(context)) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: CardContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${references[index].nodeTitle}",
                        style: TextStyles.title4,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "by ${references[index].contributors.map((e) => e)}",
                        style: TextStyles.bodyGrey,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        references[index].publishDate.toString(),
                        style: TextStyles.bodyGrey,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
              );
            } else {
              if (index == 0) {
                return Padding(
                  padding: Responsive.isDesktop(context) ? const EdgeInsets.all(10) : const EdgeInsets.all(5),
                  child: Text(
                    "References",
                    style: Responsive.isDesktop(context) ? TextStyles.title2secondary : TextStyles.title3secondary,
                    textAlign: Responsive.isDesktop(context) ? TextAlign.center : TextAlign.start,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: CardContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${references[index - 1].nodeTitle}",
                          style: TextStyles.title4,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "by ${references[index - 1].contributors.map((e) => e)}",
                          style: TextStyles.bodyGrey,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          references[index - 1].publishDate.toString(),
                          style: TextStyles.bodyGrey,
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
