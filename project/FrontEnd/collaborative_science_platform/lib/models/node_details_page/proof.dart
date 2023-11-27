class Proof {
  //int proofID;
  //String proofTitle;
  String proofContent;
  //bool isValid;
  //bool isDisproof;
  String publishDate;

  Proof({
    //required this.proofID,
    //required this.proofTitle,
    required this.proofContent,
    //required this.isValid,
    //required this.isDisproof,
    required this.publishDate,
  });

  factory Proof.fromJson(Map<String, dynamic> jsonString) {
    return Proof(
      publishDate: jsonString['publish_date'],
      //proofID: jsonString.containsKey('proof_id') ? jsonString['proof_id'] : "",
      //proofTitle: jsonString.containsKey('proof_title') ? jsonString['proof_title'] : "",
      proofContent: jsonString['proof_content'],
      //isValid: jsonString.containsKey('is_valid') ? jsonString['is_valid'] : false,
      //isDisproof: jsonString.containsKey('is_disproof') ? jsonString['is_disproof'] : false,
    );
  }
}
