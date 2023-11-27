import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:convert';

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
          itemCount: proof.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: CardContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   proof[index].isDisproof ? "Disproof" : "Proof",
                    //   style: TextStyles.bodyGrey,
                    //   textAlign: TextAlign.start,
                    // ),
                    // Text(
                    //   proof[index].proofTitle,
                    //   style: TextStyles.title4,
                    //   textAlign: TextAlign.start,
                    // ),
                    TeXView(
                        renderingEngine: TeXViewRenderingEngine.katex(),
                        child: TeXViewDocument(utf8.decode(proof[index].proofContent.codeUnits))),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Icon(
                    //       proof[index].isValid ? Icons.check : Icons.clear,
                    //       color: proof[index].isValid ? AppColors.successColor : AppColors.dangerColor,
                    //     ),
                    //     Text(
                    //       proof[index].isValid ? "valid" : "invalid",
                    //       style: TextStyles.bodyGrey,
                    //       textAlign: TextAlign.end,
                    //     ),
                    //   ],
                    // ),
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
          }),
    );
  }
}
