import 'package:collaborative_science_platform/exceptions/question_exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AskQuestionForm extends StatefulWidget {
  final int nodeId;
  final Function(Question) onQuestionPosted;
  const AskQuestionForm({Key? key, required this.nodeId, required this.onQuestionPosted})
      : super(key: key);

  @override
  State<AskQuestionForm> createState() => _AskQuestionFormState();
}

class _AskQuestionFormState extends State<AskQuestionForm> {
  bool error = false;
  String errorMessage = "";
  bool isLoading = false;

  TextEditingController questionController = TextEditingController();

  void askQuestion() async {
    try {
      if (questionController.text.isNotEmpty) {
        final questionProvider = Provider.of<QuestionAnswerProvider>(context, listen: false);
        User user = Provider.of<Auth>(context, listen: false).user!;
        setState(() {
          isLoading = true;
        });
        await questionProvider.postQuestion(questionController.text, widget.nodeId, user);
        widget.onQuestionPosted(questionProvider.questions.last);
        questionController.clear();
      }
    } on PostQuestionError {
      setState(() {
        error = true;
        errorMessage = PostQuestionError().message;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Ask a Question',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: questionController,
          decoration: const InputDecoration(labelText: 'Your Question'),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: isLoading ? null : askQuestion,
          child: const Text('Submit Question'),
        ),
        if (error) Text(errorMessage, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
