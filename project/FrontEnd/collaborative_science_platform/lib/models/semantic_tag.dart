class SemanticTag {
  final String wid;
  final String label;
  final String description;

  SemanticTag({
    required this.wid,
    required this.label,
    required this.description,
  });

  factory SemanticTag.fromJson(Map<String, dynamic> json) {
    return SemanticTag(
      wid: json['id'],
      label: json['label'],
      description: json['description'],
    );
  }

  factory SemanticTag.fromJsonforNodeDetailPage(Map<String, dynamic> json) {
    return SemanticTag(
      wid: json['wid'].toString(),
      label: json['label'],
      description: "",
    );
  }
}
