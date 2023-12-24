
class WorkspaceSemanticTag {
  final String id;
  final String label;

  WorkspaceSemanticTag({
    required this.id,
    required this.label,
  });

  factory WorkspaceSemanticTag.fromJson(Map<String, dynamic> json) {
    return WorkspaceSemanticTag(
      id: json['id'],
      label: json['label'],
    );
  }
}