class Proof {
  int proofID;
  String proofTitle;
  String proofContent;
  bool isValid;
  bool isDisproof;
  String publishDate;

  Proof({
    required this.proofID,
    required this.proofTitle,
    required this.proofContent,
    required this.isValid,
    required this.isDisproof,
    required this.publishDate,
  });

  factory Proof.fromJson(Map<String, dynamic> jsonString) {
    return Proof(
      publishDate: jsonString['publish_date'],
      proofID: jsonString['proof_id'],
      proofTitle: jsonString['proof_title'],
      proofContent: jsonString['proof_content'],
      isValid: jsonString['is_valid'],
      isDisproof: jsonString['is_disproof'],
    );
  }
}
