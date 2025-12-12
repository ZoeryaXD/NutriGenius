import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/history/data/models/food_model.dart';

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
    CREATE TABLE journal_details (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      food_name TEXT NOT NULL,
      calories REAL NOT NULL,
      image_path TEXT NOT NULL,
      created_at TEXT NOT NULL,
      meal_type_id INTEGER,
      portion_size REAL
    )
    ''');

    await db.insert('journal_details', {
      'food_name': 'Apple',
      'calories': 95.0,
      'image_path': 'path/to/apple_image.jpg',
      'created_at': DateTime.now().toString(),
      'meal_type_id': 1,
      'portion_size': 1.0,
    });
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
