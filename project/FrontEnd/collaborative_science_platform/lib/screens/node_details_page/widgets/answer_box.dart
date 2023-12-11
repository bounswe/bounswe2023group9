import 'package:collaborative_science_platform/exceptions/question_exceptions.dart';
import 'package:collaborative_science_platform/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerBox extends StatefulWidget {
  final int nodeId;

  const AnswerBox({Key? key, required this.nodeId}) : super(key: key);

  @override
  State<AnswerBox> createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  TextEditingController answerController = TextEditingController();
  bool isLoading = false;
  bool error = false;
  String errorMessage = '';

  void answerQuestion() async {
    try {
      if (answerController.text.isNotEmpty) {
        final questionAnswerProvider = Provider.of<QuestionAnswerProvider>(context, listen: false);
        setState(() {
          isLoading = true;
        });
        await questionAnswerProvider.postAnswer(answerController.text, widget.nodeId);
        answerController.clear();
      }
    } on PostAnswerError {
      setState(() {
        error = true;
        errorMessage = PostAnswerError().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your UI code here
    // Example: A text field and a button for answering
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: answerController,
          decoration: const InputDecoration(labelText: 'Your Answer'),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: isLoading ? null : answerQuestion,
          child: const Text('Submit Answer'),
        ),
        if (error) Text(errorMessage, style: const TextStyle(color: Colors.red)),
      ],
    );
  }
}
