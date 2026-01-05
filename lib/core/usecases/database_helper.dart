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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Di dalam file DatabaseHelper.dart, update fungsi _createDB
  Future _createDB(Database db, int version) async {
    // Tabel User yang sudah ada
    await db.execute('''
    CREATE TABLE users (
      email TEXT PRIMARY KEY,
      gender TEXT, birthDate TEXT,
      weight REAL, height REAL,
      activityId INTEGER, healthId INTEGER,
      bmr REAL, tdee REAL
    )
  ''');

    // TAMBAHKAN INI: Tabel untuk menyimpan history scan lokal
    await db.execute('''
    CREATE TABLE local_scans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      foodName TEXT,
      calories REAL,
      protein REAL,
      carbs REAL,
      fat REAL,
      sugar REAL,
      imagePath TEXT,
      date TEXT
    )
  ''');
  }
}
