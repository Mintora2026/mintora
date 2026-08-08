import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/record_model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance =
      DatabaseHelper._();

  static Database? _database;

  static const String _databaseName =
      'mintora.db';

  static const int _databaseVersion = 4;

  static const String recordsTable =
      'records';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database =
        await _initializeDatabase();

    return _database!;
  }

  Future<Database>
      _initializeDatabase() async {
    final databasePath =
        await getDatabasesPath();

    final path = join(
      databasePath,
      _databaseName,
    );

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute(
      '''
      CREATE TABLE $recordsTable (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        growthPoints INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        mediaPath TEXT,
        location TEXT,
        tags TEXT NOT NULL DEFAULT '[]'
      )
      ''',
    );
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        '''
        ALTER TABLE $recordsTable
        ADD COLUMN isFavorite INTEGER
        NOT NULL DEFAULT 0
        ''',
      );
    }

    if (oldVersion < 3) {
      await db.execute(
        '''
        ALTER TABLE $recordsTable
        ADD COLUMN mediaPath TEXT
        ''',
      );
    }

    if (oldVersion < 4) {
      await db.execute(
        '''
        ALTER TABLE $recordsTable
        ADD COLUMN location TEXT
        ''',
      );

      await db.execute(
        '''
        ALTER TABLE $recordsTable
        ADD COLUMN tags TEXT
        NOT NULL DEFAULT '[]'
        ''',
      );

      await _migrateMemoryMetadata(
        db,
      );
    }
  }

  Future<void> _migrateMemoryMetadata(
    Database db,
  ) async {
    final memories = await db.query(
      recordsTable,
      where: 'category = ?',
      whereArgs: [
        RecordCategory.memory.name,
      ],
    );

    for (final row in memories) {
      final id = row['id'] as String?;

      if (id == null) {
        continue;
      }

      final description =
          row['description']
                  as String? ??
              '';

      final parsed =
          _extractMemoryMetadata(
        description,
      );

      await db.update(
        recordsTable,
        {
          'description':
              parsed.description,
          'location':
              parsed.location,
          'tags': jsonEncode(
            parsed.tags,
          ),
        },
        where: 'id = ?',
        whereArgs: [
          id,
        ],
      );
    }
  }

  _MemoryMetadata _extractMemoryMetadata(
    String description,
  ) {
    String? location;

    final tags = <String>[];
    final contentLines = <String>[];

    for (final line
        in description.split('\n')) {
      final trimmed = line.trim();

      if (trimmed.startsWith(
        'Location:',
      )) {
        final value = trimmed
            .substring(
              'Location:'.length,
            )
            .trim();

        if (value.isNotEmpty) {
          location = value;
        }

        continue;
      }

      if (trimmed.startsWith(
        'Tags:',
      )) {
        final value = trimmed
            .substring(
              'Tags:'.length,
            )
            .trim();

        if (value.isNotEmpty) {
          tags.addAll(
            value
                .split(',')
                .map(
                  (tag) => tag.trim(),
                )
                .where(
                  (tag) =>
                      tag.isNotEmpty,
                ),
          );
        }

        continue;
      }

      contentLines.add(
        line,
      );
    }

    return _MemoryMetadata(
      description:
          contentLines.join('\n').trim(),
      location: location,
      tags: tags,
    );
  }

  Future<void> insertRecord(
    RecordModel record,
  ) async {
    final db = await database;

    final map = record.toMap();

    map['isCompleted'] =
        record.isCompleted ? 1 : 0;

    map['isFavorite'] =
        record.isFavorite ? 1 : 0;

    await db.insert(
      recordsTable,
      map,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<RecordModel>>
      getRecords() async {
    final db = await database;

    final maps = await db.query(
      recordsTable,
      orderBy: 'createdAt DESC',
    );

    return maps.map(
      (map) {
        final convertedMap =
            Map<String, dynamic>.from(
          map,
        );

        convertedMap['isCompleted'] =
            map['isCompleted'] == 1;

        convertedMap['isFavorite'] =
            map['isFavorite'] == 1;

        return RecordModel.fromMap(
          convertedMap,
        );
      },
    ).toList();
  }

  Future<void> updateRecord(
    RecordModel record,
  ) async {
    final db = await database;

    final map = record.toMap();

    map['isCompleted'] =
        record.isCompleted ? 1 : 0;

    map['isFavorite'] =
        record.isFavorite ? 1 : 0;

    await db.update(
      recordsTable,
      map,
      where: 'id = ?',
      whereArgs: [
        record.id,
      ],
    );
  }

  Future<void> deleteRecord(
    String id,
  ) async {
    final db = await database;

    await db.delete(
      recordsTable,
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  Future<void> clearRecords() async {
    final db = await database;

    await db.delete(
      recordsTable,
    );
  }
}

class _MemoryMetadata {
  final String description;
  final String? location;
  final List<String> tags;

  const _MemoryMetadata({
    required this.description,
    required this.location,
    required this.tags,
  });
}