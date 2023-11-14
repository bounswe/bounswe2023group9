import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

import '../../../models/node_details_page/question.dart';


class QuestionsView extends StatelessWidget {
  final List<Question> questions;
  const QuestionsView({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.desktopPageWidth,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: Responsive.isDesktop(context) ? questions.length : questions.length + 1,
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
                        "Q: ${questions[index].content}",
                        style: TextStyles.title4black,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "asked by ${questions[index].asker} at ${questions[index].createdAt}",
                        style: TextStyles.bodyGrey,
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        "A: ${questions[index].answer}",
                        style: TextStyles.bodyBlack,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "answered by ${questions[index].answerer} at ${questions[index].answeredAt}",
                        style: TextStyles.bodyGrey,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
