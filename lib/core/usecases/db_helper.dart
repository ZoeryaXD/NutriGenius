import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/history/data/models/food_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nutrigenius_hybrid.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE journal_details (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      food_name TEXT NOT NULL,
      calories REAL NOT NULL,
      image_path TEXT,
      created_at TEXT NOT NULL,
      is_synced INTEGER DEFAULT 0
    )
    ''');
  }

  Future<int> insertFood(FoodModel food) async {
    final db = await instance.database;
    return await db.insert('journal_details', food.toMap());
  }

  Future<List<FoodModel>> getHistory() async {
    final db = await instance.database;
    final result = await db.query(
      'journal_details',
      orderBy: 'created_at DESC',
    );
    return result.map((json) => FoodModel.fromMap(json)).toList();
  }
}
