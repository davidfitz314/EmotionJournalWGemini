class JournalFields {
  static const List<String> values = [id, title];
  static const String tableName = 'journal_entries';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  // static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String title = 'title';
  // static const String number = 'number';
  static const String content = 'content';
  // static const String isFavorite = 'is_favorite';
  static const String createdDate = 'created_date';
}
