import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/helpers/node_helper.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/widgets/annotation_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:convert';

class GraphPageNodeCard extends StatelessWidget {
  final NodeDetailed node;
  final Color? color;
  final Function() onTap;

  const GraphPageNodeCard({
    super.key,
    required this.node,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: onTap, // Navigate to the screen of the Node
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AnnotationText(
                          utf8.decode(node.nodeTitle.codeUnits),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(8.0), // Add padding inside the box
                      child: TeXView(
                        renderingEngine: const TeXViewRenderingEngine.katex(),
                        child: TeXViewDocument(
                          NodeHelper.getNodeContentLatex(node, "long"),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: node.contributors.length,
                      itemBuilder: (context, index) {
                        return SelectableText(
                          "${node.contributors[index].firstName} ${node.contributors[index].lastName} (${node.contributors[index].email})",
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: Colors.black54,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectableText(
                          getDurationFromNow(node.publishDate!),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
