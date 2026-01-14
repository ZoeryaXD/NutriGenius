import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecases/database_helper.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final DatabaseHelper databaseHelper;
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.databaseHelper,
    required this.sharedPreferences,
    required this.networkInfo,
  });

  String get _email => FirebaseAuth.instance.currentUser?.email ?? "";

  @override
  Future<ProfileEntity> getProfile() async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getProfile(_email);
    } else {
      throw Exception("Koneksi internet terputus.");
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final data = {
      'email': _email,
      'full_name': profile.fullName,
      'gender': profile.gender,
      'birth_date': profile.birthDate.toIso8601String(),
      'weight_kg': profile.weight,
      'height_cm': profile.height,
      'activity_id': profile.activityId,
      'health_id': profile.healthId,
    };
    await remoteDataSource.updateProfile(data);
  }

  @override
  Future<String> uploadPhoto(File imageFile) async {
    return await remoteDataSource.uploadPhoto(_email, imageFile);
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount(_email);
    await FirebaseAuth.instance.currentUser?.delete();
    await _clearLocalData();
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _clearLocalData();
  }

  Future<void> _clearLocalData() async {
    await databaseHelper.clearHistory();
    await sharedPreferences.clear();
  }

  @override
  Future<List<ActivityLevel>> getActivityLevels() async {
    final models = await remoteDataSource.getActivityLevels();
    return models
        .map(
          (m) => ActivityLevel(
            id: m.id,
            levelName: m.levelName,
            multiplier: m.multiplier,
            description: m.description,
          ),
        )
        .toList();
  }

  @override
  Future<List<HealthCondition>> getHealthConditions() async {
    final models = await remoteDataSource.getHealthConditions();
    return models
        .map(
          (m) => HealthCondition(
            id: m.id,
            conditionName: m.conditionName,
            sugarLimit: m.sugarLimit,
            description: m.description,
          ),
        )
        .toList();
  }

  @override
  Future<void> deletePhoto() async {
    await remoteDataSource.deletePhoto(_email);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
