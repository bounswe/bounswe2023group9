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
  bool showAnnotations = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth - 50,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
            showAnnotations
                ? ProofItemWidget(proof: widget.proof)
                : ProofTexView(proof: widget.proof),
          ],
        ),
      ),
    );
  }
}

class ProofTexView extends StatelessWidget {
  final List<Proof> proof;
  const ProofTexView({
    super.key,
    required this.proof,
  });

  @override
  Widget build(BuildContext context) {
    return TeXView(
      renderingEngine: const TeXViewRenderingEngine.katex(),
      child: TeXViewColumn(
        children: [
          for (int i = 0; i < proof.length; i++)
            TeXViewContainer(
              child: TeXViewDocument(
                proof[i].proofContent,
              ),
              style: const TeXViewStyle(
                margin: TeXViewMargin.all(10),
                elevation: 5,
                padding: TeXViewPadding.all(16),
                borderRadius: TeXViewBorderRadius.all(5),
                backgroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class ProofItemWidget extends StatelessWidget {
  final List<Proof> proof;

  const ProofItemWidget({Key? key, required this.proof}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < proof.length; i++)
          Padding(
            padding: const EdgeInsets.all(5),
            child: CardContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnnotationText(
                    utf8.decode(proof[i].proofContent.codeUnits),
                    annotationType: AnnotationType.proof,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        proof[i].publishDate.toString(),
                        style: TextStyles.bodyGrey,
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
