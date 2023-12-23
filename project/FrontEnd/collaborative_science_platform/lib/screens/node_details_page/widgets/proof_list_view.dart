import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/providers/annotation_provider.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/annotation_text.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:convert';

class ProofListView extends StatefulWidget {
  final List<Proof> proof;

  const ProofListView({super.key, required this.proof});

  @override
  State<ProofListView> createState() => _ProofListViewState();
}

class _ProofListViewState extends State<ProofListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: SingleChildScrollView(
        child: Column(
          children: widget.proof.map((proof) => ProofItemWidget(proof: proof)).toList(),
        ),
      ),
    );
  }
}

class ProofItemWidget extends StatefulWidget {
  final Proof proof;

  ProofItemWidget({Key? key, required this.proof}) : super(key: key);

  @override
  _ProofItemWidgetState createState() => _ProofItemWidgetState();
}

class _ProofItemWidgetState extends State<ProofItemWidget> {
  bool showAnnotations = true;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Delay the rendering of TeXView
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Conditional rendering based on isLoaded
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 180,
                  child: AppButton(
                      text: showAnnotations ? "Show Text" : "Show Annotations",
                      height: 40,
                      onTap: () {
                        setState(() {
                          showAnnotations = !showAnnotations;
                        });
                      }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            showAnnotations
                ? AnnotationText(
                    utf8.decode(widget.proof.proofContent.codeUnits),
                    annotationType: AnnotationType.proof,
                  )
                : isLoaded
                    ? TeXView(
                        renderingEngine: const TeXViewRenderingEngine.katex(),
                        child: TeXViewDocument(utf8.decode(widget.proof.proofContent.codeUnits)))
                    : SizedBox.shrink(),
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
                  widget.proof.publishDate.toString(),
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
