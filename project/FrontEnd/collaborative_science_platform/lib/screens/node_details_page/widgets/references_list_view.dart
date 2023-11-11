import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ReferencesView extends StatelessWidget {
  final List<NodeDetailed> nodes;
  final bool ref;
  const ReferencesView({super.key, required this.nodes, this.ref = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: nodes.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: CardContainer(
                onTap: () {
                  Navigator.pushNamed(context, NodeDetailsPage.routeName,
                      arguments: nodes[index].nodeId);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nodes[index].nodeTitle,
                      style: TextStyles.title4,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      nodes[index].publishDate.toString(),
                      style: TextStyles.bodyGrey,
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

    //         } else {
    //           if (index == 0) {
    //             return Padding(
    //               padding: const EdgeInsets.all(5),
    //               child: Text(
    //                 ref! ? "References" : "Citations",
    //                 style: TextStyles.title3secondary,
    //                 textAlign: TextAlign.start,
    //               ),
    //             );
    //           } else {
    //             return Padding(
    //               padding: const EdgeInsets.all(5),
    //               child: CardContainer(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       "${nodes[index - 1].nodeTitle}",
    //                       style: TextStyles.title4,
    //                       textAlign: TextAlign.start,
    //                     ),
    //                     Text(
    //                       "${nodes[index - 1].publishDate.toString()}",
    //                       style: TextStyles.bodyGrey,
    //                       textAlign: TextAlign.start,
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             );
    //           }
    //         }
    //       }),
    // );