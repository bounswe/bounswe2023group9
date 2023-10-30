class NodeDetailed {
  int nodeId;
  String nodeTitle;
  String publishDate;
  List<int> contributors;
  List<int> proof;
  int theorem;
  //List<User> reviewers;
  List<int> references;
  List<int> citations;
  bool isValid;
  int noVisits;

  //List<Question> questions;
  //List<SemanticTag> semanticTags;
  //List<WikiTag> wikiTags;
  //List<Annotation> annotations;

  NodeDetailed({
    this.nodeId = 0,
    this.nodeTitle = "",
    this.contributors = const [],
    this.proof = const [],
    this.theorem = 0,
    this.publishDate = "",
    //required this.reviewers,
    this.references = const [],
    this.citations = const [],
    this.isValid = true,
    this.noVisits = 0,

    //required this.semanticTags,
    //required this.wikiTags,
    //required this.annotations,
    //required this.questions,
  });

  factory NodeDetailed.fromJson(Map<String, dynamic> jsonString) {
    var referencesList = jsonString['from_referenced_nodes'] as List;
    var citationsList = jsonString['to_referenced_nodes'] as List;
    List<int> references =
        referencesList.map((e) => int.parse(e.toString())).toList();
    List<int> citations =
        citationsList.map((e) => int.parse(e.toString())).toList();
    var contributorsList = jsonString['contributors'] as List;
    //var reviewersList = jsonString['reviewers'] as List;
    List<int> contributors =
        contributorsList.map((e) => int.parse(e.toString())).toList();
    //List<User> reviewers = reviewersList.map((e) => User.fromJson(e)).toList();

    var proofsList = jsonString['proofs'] as List;
    List<int> proof = proofsList.map((e) => int.parse(e.toString())).toList();
    //var theorem = Theorem.fromJson(jsonString['theorem']);

    return NodeDetailed(
        nodeId: jsonString['node_id'],
        nodeTitle: jsonString['node_title'],
        contributors: contributors,
        proof: proof,
        theorem: jsonString['theorem'],
        publishDate: jsonString['publish_date'],
        //reviewers: reviewers,
        references: references,
        citations: citations,
        isValid: jsonString['is_valid'],
        noVisits: jsonString['num_visits']);
  }
}
