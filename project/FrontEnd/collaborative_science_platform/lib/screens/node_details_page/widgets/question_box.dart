import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/answer_box.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/providers/admin_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionBox extends StatefulWidget {
  final Question question;
  final bool canAnswer;
  final bool isAdmin;
  final Function() onTap;

  const QuestionBox({
    super.key,
    required this.question,
    required this.canAnswer,
    required this.isAdmin,
    required this.onTap,
  });

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  bool isHidden = false;
  bool isReplyVisible = false;
  TextEditingController answerController = TextEditingController();

  void changeQuestionStatus() async {
    try {
      final User? admin = Provider.of<Auth>(context, listen: false).user;
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      int response =
          await adminProvider.hideQuestion(admin, widget.question, !widget.question.isHidden);
    } catch (e) {
      print("Error");
      setState(() {});
    }
  }

  void handleButton() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isHidden = widget.question.isHidden;
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q: ${widget.question.content}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text('Asked by: ${widget.question.asker.email} at ${widget.question.createdAt}'),
                if (widget.question.isAnswered)
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
                if (widget.question.isAnswered == false && widget.canAnswer)
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
                      if (isReplyVisible)
                        AnswerBox(
                          questionId: widget.question.id,
                          onQuestionAnswered: () => setState(() {}),
                        ),
                    ],
                  ),
              ],
            ),
            Visibility(
              visible: widget.isAdmin, //visible only to admin
              child: isHidden //button view will change according to this
                  ? SizedBox(
                      width: 110,
                      child: AppButton(
                        text: "Show",
                        height: 40,
                        icon: const Icon(
                          CupertinoIcons.eye,
                          size: 16,
                          color: Colors.white,
                        ),
                        type: "grey",
                        onTap: () {
                          changeQuestionStatus();
                          handleButton();
                          widget.onTap(); // Call the onTap callback here
                        },
                      ),
                    )
                  : SizedBox(
                      width: 110,
                      child: AppButton(
                        text: "Hide",
                        height: 40,
                        icon: const Icon(
                          CupertinoIcons.eye_slash,
                          size: 16,
                          color: Colors.white,
                        ),
                        type: "danger",
                        onTap: () {
                          changeQuestionStatus();
                          handleButton();
                          widget.onTap(); // Call the onTap callback here
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
