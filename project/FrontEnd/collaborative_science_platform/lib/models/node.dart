import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/models/proof.dart';
import 'package:collaborative_science_platform/models/question.dart';
import 'package:collaborative_science_platform/models/reviewer.dart';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/models/theorem.dart';
import 'package:collaborative_science_platform/models/wiki_tag.dart';

class Node {
  int nodeId;
  String nodeTitle;
  List<Contributor> contributors;
  List<Proof> proofs;
  Theorem theorem;
  List<Question> questions;
  DateTime publishDate;
  List<Reviewer> reviewers;
  List<Node> references;
  List<SemanticTag> semanticTags;
  List<WikiTag> wikiTags;
  List<Annotation> annotations;
  bool isValid;
  int noVisits;

   Node({
    required this.nodeId,
    required this.nodeTitle,
    required this.contributors,
    required this.proofs,
    required this.theorem,
    required this.questions,
    required this.publishDate,
    required this.reviewers,
    required this.references,
    required this.semanticTags,
    required this.wikiTags,
    required this.annotations,
    required this.isValid,
    required this.noVisits,
  });
}
