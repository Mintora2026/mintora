import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/record_model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  static const String _databaseName = 'mintora.db';
  static const int _databaseVersion = 1;
  static const String recordsTable = 'records';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $recordsTable (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        growthPoints INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertRecord(RecordModel record) async {
    final db = await database;

    final map = record.toMap();
    map['isCompleted'] = record.isCompleted ? 1 : 0;

    await db.insert(
      recordsTable,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecordModel>> getRecords() async {
    final db = await database;

    final maps = await db.query(
      recordsTable,
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) {
      final convertedMap = Map<String, dynamic>.from(map);
      convertedMap['isCompleted'] = map['isCompleted'] == 1;
      return RecordModel.fromMap(convertedMap);
    }).toList();
  }
Future<void> updateRecord(RecordModel record) async {
  final db = await database;

  final map = record.toMap();
  map['isCompleted'] = record.isCompleted ? 1 : 0;

  await db.update(
    recordsTable,
    map,
    where: 'id = ?',
    whereArgs: [record.id],
  );
}
  Future<void> deleteRecord(String id) async {
    final db = await database;

    await db.delete(
      recordsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearRecords() async {
    final db = await database;
    await db.delete(recordsTable);
  }
}