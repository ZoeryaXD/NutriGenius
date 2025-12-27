import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart'; // Pastikan import sqflite
import '../../../../core/usecases/database_helper.dart'; // Sesuaikan path

abstract class DashboardLocalDataSource {
  Future<Map<String, dynamic>> getData();
  Future<void> cacheData(Map<String, dynamic> data); // <--- TAMBAHAN BARU
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final DatabaseHelper databaseHelper;
  final FirebaseAuth firebaseAuth;

  DashboardLocalDataSourceImpl({required this.databaseHelper, required this.firebaseAuth});

  @override
  Future<Map<String, dynamic>> getData() async {
    final user = firebaseAuth.currentUser;
    final String email = user?.email ?? "";
    final String name = user?.displayName ?? "User";

    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    // Jika data ada di SQLite, kembalikan
    if (maps.isNotEmpty) {
      return {
        'name': maps.first['name'] ?? name, // Prioritas nama di DB, fallback ke Firebase
        'tdee': maps.first['tdee'],
        'found': true, // Penanda bahwa data ditemukan di lokal
      };
    }

    // Jika kosong
    return {
      'name': name,
      'tdee': 2000.0,
      'found': false, // Penanda data tidak ada
    };
  }

  // <--- FUNGSI BARU: Simpan data dari Server ke SQLite
  @override
  Future<void> cacheData(Map<String, dynamic> data) async {
    final user = firebaseAuth.currentUser;
    final String email = user?.email ?? "";
    
    if (email.isEmpty) return;

    final db = await databaseHelper.database;
    
    // Siapkan data untuk disimpan ke tabel 'users'
    Map<String, dynamic> userRow = {
      'email': email,
      'name': data['displayName'], // Dari API Node.js key-nya 'displayName'
      'gender': data['gender'],
      'weight': data['weight'],
      'height': data['height'],
      'bmr': data['bmr'],
      'tdee': data['tdee'],
      // Field lain bisa diset null atau default jika API tidak kirim
    };

    await db.insert(
      'users', 
      userRow, 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}