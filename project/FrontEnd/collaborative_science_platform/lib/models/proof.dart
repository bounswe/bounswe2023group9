class Proof {
  int proofID;
  String proofTitle;
  String proofContent;
  bool isValid;
  bool isDisproof;
  DateTime publishDate;

  Proof({
    required this.proofID,
    required this.proofTitle,
    required this.proofContent,
    required this.isValid,
    required this.isDisproof,
    required this.publishDate,
  });
}
