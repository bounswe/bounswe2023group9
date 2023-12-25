import 'package:intl/intl.dart';

class Entry {
  bool isEditable;
  bool isFinalEntry;
  bool isProofEntry;
  bool isDisproofEntry;
  bool isTheoremEntry;
  DateTime entryDate;
  int entryId;
  int entryNumber;
  int index;
  String content;

  Entry({
    required this.content,
    required this.entryDate,
    required this.entryId,
    required this.entryNumber,
    required this.index,
    required this.isEditable,
    required this.isFinalEntry,
    required this.isProofEntry,
    required this.isTheoremEntry,
    required this.isDisproofEntry,
  });
  String get publishDateFormatted {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(entryDate);
  }

  factory Entry.fromJson(Map<String, dynamic> jsonString) {
    return Entry(
        isEditable: jsonString['is_editable'],
        isFinalEntry: jsonString['is_final_entry'],
        isProofEntry: jsonString['is_proof_entry'],
        isTheoremEntry: jsonString['is_theorem_entry'],
        entryDate: DateTime.parse(jsonString['entry_date']),
        entryId: jsonString['entry_id'] ?? -1,
        entryNumber: jsonString['entry_number'] ?? -1,
        index: jsonString['entry_index'] ?? -1,
      content: jsonString['content'],
      isDisproofEntry: jsonString['is_disproof_entry'],
    );
  }
}
