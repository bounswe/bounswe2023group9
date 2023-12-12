import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/answer_box.dart';
import 'package:flutter/material.dart';

class QuestionBox extends StatefulWidget {
  final Question question;

  const QuestionBox({super.key, required this.question});

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  bool isReplyVisible = false;
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: ${widget.question.content}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Asked by: ${widget.question.asker.email} at ${widget.question.createdAt}'),
            if (widget.question.answer != null && widget.question.answer!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    'A: ${widget.question.answer}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            if (widget.question.answer == null || widget.question.answer!.isEmpty)
              Column(
                children: [
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isReplyVisible = !isReplyVisible;
                        });
                      },
                      child: Text(
                        isReplyVisible ? 'Hide Reply' : 'Reply',
                      ),
                    ),
                  ),
                  if (isReplyVisible) AnswerBox(questionId: widget.question.id),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
