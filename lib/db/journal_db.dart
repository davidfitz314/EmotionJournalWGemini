import 'dart:async';

import 'package:myapp/db/journal_fields.dart';
import 'package:myapp/db/journal_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// TODO: convert this over to firebase for persistant storage accross devices
class JournalDb {
  static final JournalDb instance = JournalDb._internal();

  static Database? _database;

  JournalDb._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'journal_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${JournalFields.tableName} (
          ${JournalFields.id} ${JournalFields.idType},
          ${JournalFields.title} ${JournalFields.textType},
          ${JournalFields.createdDate} ${JournalFields.textType},
          ${JournalFields.content} ${JournalFields.textType}
        )
      ''');
  }

  Future<JournalModel> create(JournalModel entry) async {
    final db = await instance.database;
    final id = await db.insert(JournalFields.tableName, entry.toJson());
    return entry.copy(id: id);
  }

  Future<JournalModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      JournalFields.tableName,
      columns: JournalFields.values,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return JournalModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<JournalModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${JournalFields.id} DESC';
    final result = await db.query(JournalFields.tableName, orderBy: orderBy);
    return result.map((json) => JournalModel.fromJson(json)).toList();
  }

  Future<int> update(JournalModel entry) async {
    final db = await instance.database;
    return db.update(
      JournalFields.tableName,
      entry.toJson(),
      where: '${JournalFields.id} = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      JournalFields.tableName,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
