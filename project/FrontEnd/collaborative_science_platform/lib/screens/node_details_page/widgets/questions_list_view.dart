import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class Question {
  String question;
  String answer;
  Question({
    required this.question,
    required this.answer,
  });
}

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
                        "Q: ${questions[index].question}",
                        style: TextStyles.title4black,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "A: ${questions[index].answer}",
                        style: TextStyles.bodyBlack,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              if (index == 0) {
                return Padding(
                  padding: Responsive.isDesktop(context) ? const EdgeInsets.all(10) : const EdgeInsets.all(5),
                  child: Text(
                    "Q/A",
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
                          "Q: ${questions[index - 1].question}",
                          style: TextStyles.title4black,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "A: ${questions[index - 1].answer}",
                          style: TextStyles.bodyBlack,
                          textAlign: TextAlign.start,
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
