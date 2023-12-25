import 'package:collaborative_science_platform/models/workspaces_page/comment.dart';
import 'package:collaborative_science_platform/models/workspaces_page/workspace.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentsSideBar extends StatefulWidget {
  final ScrollController controller;
  final Function? hideSidebar;
  final double height;
  final List<Comment> comments;

  const CommentsSideBar({
    super.key,
    required this.controller,
    this.hideSidebar,
    required this.height,
    required this.comments,
  });

  @override
  State<CommentsSideBar> createState() => _CommentsSideBarState();
}

class _CommentsSideBarState extends State<CommentsSideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height + 100,
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppBarButton(
                      onPressed: () {
                        widget.hideSidebar!();
                      },
                      icon: CupertinoIcons.forward,
                      text: "hide comments",
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width * 0.10
                          : MediaQuery.of(context).size.width * 0.8,
                      child: (MediaQuery.of(context).size.width >= Responsive.desktopPageWidth)
                          ? const Text("Reviewer comments", style: TextStyles.title4secondary)
                          : const Text("Reviewer comments", style: TextStyles.bodySecondary),
                    )
                  ],
                ),
                SizedBox(
                    height: widget.height * 0.9,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: (widget.comments.length),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: CardContainer(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.18,
                                child: Column(
                                  children: [
                                    Text(
                                      widget.comments[index].comment,
                                    ),
                                    if (widget.comments[index].response == RequestStatus.approved)
                                      const Text(
                                        "Approved",
                                        style: TextStyle(color: Colors.green),
                                        textAlign: TextAlign.end,
                                      ),
                                    if (widget.comments[index].response == RequestStatus.rejected)
                                      const Text(
                                        "Rejected",
                                        style: TextStyle(color: Colors.red),
                                        textAlign: TextAlign.end,
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            )));
  }
}
