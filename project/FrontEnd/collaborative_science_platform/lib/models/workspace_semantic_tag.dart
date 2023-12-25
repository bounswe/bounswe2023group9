
class WorkspaceSemanticTag {
  final int tagId;
  final String wid;
  final String label;

  WorkspaceSemanticTag({
    required this.tagId,
    required this.wid,
    required this.label,
  });

  factory WorkspaceSemanticTag.fromJson(Map<String, dynamic> json) {
    return WorkspaceSemanticTag(
      tagId: json['id'],
      wid: json['wid'],
      label: json['label'],
    );
  }
}