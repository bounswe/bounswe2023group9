import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/textStyles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ProofListView extends StatelessWidget {
  final List<Proof> proof;
  const ProofListView({super.key, required this.proof});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount:
              Responsive.isDesktop(context) ? proof.length : proof.length + 1,
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
                        proof[index].isDisproof ? "Disproof" : "Proof",
                        style: TextStyles.bodyGrey,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        proof[index].proofTitle,
                        style: TextStyles.title4,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        proof[index].proofContent,
                        style: TextStyles.bodyBlack,
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            proof[index].isValid ? Icons.check : Icons.clear,
                            color: proof[index].isValid
                                ? AppColors.successColor
                                : AppColors.dangerColor,
                          ),
                          Text(
                            proof[index].isValid ? "valid" : "invalid",
                            style: TextStyles.bodyGrey,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            proof[index].publishDate.toString(),
                            style: TextStyles.bodyGrey,
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              if (index == 0) {
                return Padding(
                  padding: Responsive.isDesktop(context)
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(5),
                  child: Text(
                    "Proofs",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proof[index - 1].isDisproof ? "Disproof" : "Proof",
                          style: TextStyles.bodyGrey,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          proof[index - 1].proofTitle,
                          style: TextStyles.title4,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          proof[index - 1].proofContent,
                          style: TextStyles.bodyBlack,
                          textAlign: TextAlign.start,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              proof[index - 1].isValid
                                  ? Icons.check
                                  : Icons.clear,
                              color: proof[index - 1].isValid
                                  ? AppColors.successColor
                                  : AppColors.dangerColor,
                            ),
                            Text(
                              proof[index - 1].isValid ? "valid" : "invalid",
                              style: TextStyles.bodyGrey,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              proof[index - 1].publishDate.toString(),
                              style: TextStyles.bodyGrey,
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
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
