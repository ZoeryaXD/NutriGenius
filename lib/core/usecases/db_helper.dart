import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_name TEXT NOT NULL,
        calories REAL NOT NULL,
        protein REAL,
        carbs REAL,
        fat REAL,
        sugar REAL,
        image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        email TEXT PRIMARY KEY,
        full_name TEXT,
        gender TEXT,
        weight_kg REAL,
        height_cm REAL,
        birth_date TEXT,
        bmr REAL,
        tdee REAL
      )
    ''');
  }

  Future<int> insertFood(Map<String, dynamic> food) async {
    final db = await instance.database;
    return await db.insert('history', food);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'created_at DESC');
    return result;
  }

  Future<int> deleteFood(int id) async {
    final db = await instance.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}
