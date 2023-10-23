import 'package:collaborative_science_platform/models/contributor_user.dart';

class Entry {
  int entryId;
  int workspaceID;
  String content;
  DateTime entryDate;
  bool isTheoremEntry;
  bool isFinalEntry;
  bool isEditable;
  Contributor creator;
  List<Contributor> contributors;
  int entryNumber;

  Entry(
      {required this.entryId,
      required this.workspaceID,
      required this.content,
      required this.entryDate,
      required this.isTheoremEntry,
      required this.isFinalEntry,
      required this.isEditable,
      required this.creator,
      required this.contributors,
      required this.entryNumber});
}
