import 'package:collaborative_science_platform/helpers/date_to_string.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
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
                          // top: BorderSide(width: 2.0, color: Colors.grey),
                          bottom: BorderSide(width: 2.0, color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SelectableText(
                          utf8.decode(node.nodeTitle.codeUnits),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
                          child:
                              TeXViewDocument(utf8.decode(node.theorem!.theoremContent.codeUnits))),
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              node.contributors
                                  .map((user) =>
                                      "${user.firstName} ${user.lastName} (${user.email})")
                                  .join("\n"),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
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
                    )
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
