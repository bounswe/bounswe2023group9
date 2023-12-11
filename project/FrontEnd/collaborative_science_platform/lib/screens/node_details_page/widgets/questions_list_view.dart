import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/question_box.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/ask_question_form.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';

class QuestionsView extends StatelessWidget {
  final List<Question> questions;
  final int nodeId;

  const QuestionsView({Key? key, required this.questions, required this.nodeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: Responsive.desktopPageWidth,
        height: 1000,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AskQuestionForm(nodeId: nodeId),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return QuestionBox(
                    question: questions[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
