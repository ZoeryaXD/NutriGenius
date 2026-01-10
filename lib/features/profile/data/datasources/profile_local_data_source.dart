import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/usecases/database_helper.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final DatabaseHelper dbHelper;
  final FirebaseAuth auth;

  ProfileLocalDataSourceImpl({required this.dbHelper, required this.auth});

  @override
  Future<ProfileModel> getProfile() async {
    final email = auth.currentUser?.email;
    final db = await dbHelper.database;

    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (res.isNotEmpty) {
      return ProfileModel.fromJson(res.first);
    }
    throw Exception("Data profil lokal tidak ditemukan");
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    final db = await dbHelper.database;
    await db.insert(
      'users',
      profile.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
