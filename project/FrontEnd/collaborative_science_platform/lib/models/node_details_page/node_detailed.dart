import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/node_details_page/proof.dart';
import 'package:collaborative_science_platform/models/node_details_page/question.dart';
import 'package:collaborative_science_platform/models/theorem.dart';
import 'package:collaborative_science_platform/models/user.dart';

import 'package:intl/intl.dart';

class NodeDetailed {
  int nodeId;
  String nodeTitle;
  DateTime? publishDate;
  List<User> contributors;
  List<Proof> proof;
  Theorem? theorem;
  List<User> reviewers;
  List<Node> references;
  List<Node> citations;
  bool isValid;
  int noVisits;
  bool isHidden;
  List<Question> questions;

  //List<SemanticTag> semanticTags;
  //List<WikiTag> wikiTags;
  //List<Annotation> annotations;

  NodeDetailed({
    this.nodeId = 0,
    this.nodeTitle = "",
    this.contributors = const [],
    this.proof = const [],
    this.theorem,
    this.publishDate,
    this.reviewers = const [],
    this.references = const [],
    this.citations = const [],
    this.isValid = true,
    this.noVisits = 0,
    this.questions = const [],
    this.isHidden = false,
    //required this.semanticTags,
    //required this.wikiTags,
    //required this.annotations,
  });

  String get publishDateFormatted {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(publishDate!);
  }

  factory NodeDetailed.fromJson(Map<String, dynamic> jsonString) {
    var referencesList = jsonString['from_referenced_nodes'] as List;
    var citationsList = jsonString['to_referenced_nodes'] as List;
    var contributorsList = jsonString['contributors'] as List;
    //var reviewersList = jsonString['reviewers'] as List;
    var proofsList = jsonString['proofs'] as List;
    var theorem = Theorem.fromJson(jsonString['theorem']);
    var questionsList = jsonString['question_set'] as List;
    List<Node> references = referencesList.map((e) => Node.fromJsonforNodeDetailPage(e)).toList();
    List<Node> citations = citationsList.map((e) => Node.fromJsonforNodeDetailPage(e)).toList();
    List<User> contributors =
        contributorsList.map((e) => User.fromJsonforNodeDetailPage(e)).toList();
    //List<User> reviewers = reviewersList.map((e) => User.fromJsonforNodeDetailPage(e)).toList();
    List<Proof> proof = proofsList.map((e) => Proof.fromJson(e)).toList();
    List<Question> questions = questionsList.map((e) => Question.fromJson(e)).toList();
    return NodeDetailed(
      citations: citations,
      contributors: contributors,
      isValid: jsonString['is_valid'],
      isHidden: jsonString['removed_by_admin'],
      nodeId: jsonString['node_id'],
      nodeTitle: jsonString['node_title'],
      noVisits: jsonString['num_visits'],
      proof: proof,
      publishDate: DateTime.parse(jsonString['publish_date']),
      questions: questions,
      references: references,
      //reviewers: reviewers,
      theorem: theorem,
    );
  }
}
