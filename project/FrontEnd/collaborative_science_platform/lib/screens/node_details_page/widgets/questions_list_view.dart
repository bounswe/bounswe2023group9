import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/question_box.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/ask_question_form.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';

class QuestionsView extends StatefulWidget {
  final int nodeId;
  final List<Question> questions;
  final bool canAnswer;
  final bool canAsk;
  final bool isAdmin;
  final bool isHidden;

  const QuestionsView(
      {Key? key,
      required this.nodeId,
      required this.questions,
      required this.canAnswer,
      required this.canAsk,
      required this.isAdmin,
      required this.isHidden})
      : super(key: key);

  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      questions = widget.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Question> filteredQuestions = questions.where((question) {
      return question.isAnswered || widget.canAnswer;
    }).toList();

    return SingleChildScrollView(
      child: Container(
        width: Responsive.desktopPageWidth,
        height: 1000,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.canAsk)
              AskQuestionForm(
                nodeId: widget.nodeId,
                onQuestionPosted: (Question newQuestion) {
                  setState(() {
                    questions.add(newQuestion);
                  });
                },
              ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredQuestions.length,
                itemBuilder: (BuildContext context, int index) {
                  return QuestionBox(
                    isAdmin: widget.isAdmin,
                    isHidden: widget.isHidden,
                    question: filteredQuestions[index],
                    canAnswer: widget.canAnswer,
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
