import 'package:myapp/db/journal_fields.dart';

class JournalModel {
  final int id;
  final String title;
  final DateTime createdDate;

  const JournalModel(
      {required this.id, required this.title, required this.createdDate});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'created_date': createdDate,
    };
  }

  Map<String, Object?> toJson() => {
        JournalFields.id: id,
        JournalFields.title: title,
        JournalFields.createdDate: createdDate,
      };

  @override
  String toString() {
    return 'JournalEntry{id: $id, name: $title, createdDate: $createdDate}';
  }

  JournalModel copy({
    int? id,
    String? title,
    DateTime? createdDate,
  }) =>
      JournalModel(
        id: id ?? this.id,
        title: title ?? this.title,
        createdDate: createdDate ?? this.createdDate,
      );

  factory JournalModel.fromJson(Map<String, Object?> json) => JournalModel(
        id: json[JournalFields.id] as int,
        title: json[JournalFields.title] as String,
        createdDate: json[JournalFields.createdDate] as DateTime,
      );
}
