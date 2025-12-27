import 'package:sqflite/sqflite.dart';
import '../../../../core/usecases/database_helper.dart';
import '../models/firstpage_model.dart';

abstract class FirstPageLocalDataSource {
  Future<void> cacheProfile(FirstPageModel profile);
}

class FirstPageLocalDataSourceImpl implements FirstPageLocalDataSource {
  final DatabaseHelper databaseHelper;

  FirstPageLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheProfile(FirstPageModel profile) async {
    final db = await databaseHelper.database;
    
    // Simpan ke SQLite (ConflictAlgorithm.replace artinya kalau ada data lama, timpa)
    await db.insert(
      'users',
      profile.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}