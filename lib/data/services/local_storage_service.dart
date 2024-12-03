import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  Database? _database;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'app_data.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL
        )
      ''');
      },
    );
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<void> saveHistoryEntries(List<DateTime> entries) async {
    final db = await database;

    await db.delete('history');

    for (var entry in entries) {
      print('Inserting entry: ${entry.toIso8601String()}');
      await db.insert(
        'history',
        {'date': entry.toIso8601String()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    print('History entries saved.');
  }

  Future<List<DateTime>> getHistoryEntries() async {
    final db = await database;
    final result = await db.query('history');
    return result.map((row) => DateTime.parse(row['date'] as String)).toList();
  }
}
