import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/question_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionActivity extends StatelessWidget {
  final bool isAdmin;
  final bool isHidden;
  final List<Question> questions;
  const QuestionActivity(
      {Key? key, required this.isAdmin, required this.isHidden, required this.questions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            context.push("${NodeDetailsPage.routeName}/${questions[index].nodeId}");
          },
          child: QuestionBox(
            isAdmin: isAdmin,
            question: questions[index],
            canAnswer: false,
            onTap: () {},
          ),
        );
      },
    );
  }
}
