import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/question_box.dart';
import 'package:flutter/material.dart';

class QuestionActivity extends StatelessWidget {
  final List<Question> questions;

  const QuestionActivity({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        return QuestionBox(
          question: "Q: ${questions[index].content}",
          askedBy: "asked by ${questions[index].asker} at ${questions[index].createdAt}",
          answer: "A: ${questions[index].answer}",
        );
      },
    );
  }
}
