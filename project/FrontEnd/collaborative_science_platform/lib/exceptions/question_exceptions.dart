class PostQuestionError implements Exception {
  String message;
  PostQuestionError({this.message = "Post Question Error"});
}

class PostAnswerError implements Exception {
  String message;
  PostAnswerError({this.message = "Post Answer Error"});
}
