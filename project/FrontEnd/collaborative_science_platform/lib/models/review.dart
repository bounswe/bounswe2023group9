import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/models/reviewer.dart';
import 'package:collaborative_science_platform/models/status.dart';

class Review{
  Status status;
  List<Annotation> annotations;
  Reviewer reviewer;
  List<String> comments;

  Review({
    required this.status,
    required this.annotations,
    required this.reviewer,
    required this.comments,
  });
}