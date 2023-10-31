class Theorem {
  int theoremID;
  String theoremTitle;
  String theoremContent;
  String publishDate;

  Theorem(
      {this.theoremID = 0,
      this.theoremTitle = "",
      this.theoremContent = "",
      this.publishDate = ""});

  factory Theorem.fromJson(Map<String, dynamic> jsonString) {
    return Theorem(
      publishDate: jsonString['publish_date'],
      theoremID: jsonString['theorem_id'],
      theoremTitle: jsonString['theorem_title'],
      theoremContent: jsonString['theorem_content'],
    );
  }
}
