class Theorem {
  String theoremContent;
  String publishDate;

  Theorem(
      {
      this.theoremContent = "",
      this.publishDate = ""});

  factory Theorem.fromJson(Map<String, dynamic> jsonString) {
    return Theorem(
      publishDate: jsonString['publish_date'],
      theoremContent: jsonString['theorem_content'],
    );
  }
}
