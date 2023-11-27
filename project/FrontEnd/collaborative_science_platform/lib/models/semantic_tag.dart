class SemanticTag {
  final String id;
  final String label;
  final String description;

  SemanticTag({
    required this.id,
    required this.label,
    required this.description,
  });

  factory SemanticTag.fromJson(Map<String, dynamic> json) {
    return SemanticTag(
      id: json['id'],
      label: json['label'],
      description: json['description'],
    );
  }
}
