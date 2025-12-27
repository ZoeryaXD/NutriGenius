import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/usecases/database_helper.dart';

abstract class DashboardLocalDataSource {
  Future<Map<String, dynamic>> getData();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final DatabaseHelper databaseHelper;
  final FirebaseAuth firebaseAuth;

  DashboardLocalDataSourceImpl({required this.databaseHelper, required this.firebaseAuth});

  @override
  Future<Map<String, dynamic>> getData() async {
    // 1. Ambil Nama dari Firebase Auth
    final user = firebaseAuth.currentUser;
    final String name = user?.displayName ?? "User";
    final String email = user?.email ?? "";

    // 2. Ambil TDEE dari SQLite berdasarkan email
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    double tdee = 2000; // Default jika data tidak ditemukan
    if (maps.isNotEmpty) {
      tdee = maps.first['tdee'] as double;
    }

    return {
      'name': name,
      'tdee': tdee,
    };
  }
}