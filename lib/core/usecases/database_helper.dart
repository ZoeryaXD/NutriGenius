import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nutrigenius.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      email TEXT PRIMARY KEY,
      gender TEXT,
      birthDate TEXT,
      weight REAL,
      height REAL,
      activityId INTEGER,
      healthId INTEGER,
      bmr REAL,
      tdee REAL
    )
    ''');

    await db.execute('''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      food_name TEXT NOT NULL,
      calories REAL NOT NULL,
      protein REAL,
      carbs REAL,
      fat REAL,
      sugar REAL,
      created_at TEXT NOT NULL, 
      image_path TEXT
    )
    ''');
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    try {
      return await db.query('history', orderBy: 'created_at DESC');
    } catch (e) {
      print("Gagal query SQLite: $e");
      return [];
    }
  }

  Future<int> insertFood(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('history', row);
  }

  Future<int> deleteFood(int id) async {
    final db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
