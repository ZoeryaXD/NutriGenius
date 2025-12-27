import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Driver Windows
import 'dart:io'; // Untuk cek apakah ini Windows atau Android

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

  Future _createDB(Database db, int version) async {
    // Tabel Users (Cache Profil)
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
    
    // Nanti bisa tambah tabel daily_journals disini juga
  }
}