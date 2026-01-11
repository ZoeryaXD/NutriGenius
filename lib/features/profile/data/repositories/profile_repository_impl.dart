import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  String get _email => FirebaseAuth.instance.currentUser!.email!;

  @override
  Future<ProfileEntity> getProfile() async {
    return await remoteDataSource.getProfile(_email);
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
  Future<void> deletePhoto() async {
    await remoteDataSource.deletePhoto(_email);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount(_email);
    await FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<List<ActivityLevel>> getActivityLevels() async {
    final models = await remoteDataSource.getActivityLevels();
    
    return models.map((model) => ActivityLevel(
      id: model.id,
      levelName: model.levelName,
      multiplier: model.multiplier,
      description: model.description,
    )).toList();
  }

  @override
  Future<List<HealthCondition>> getHealthConditions() async {
    final models = await remoteDataSource.getHealthConditions();
    
    return models.map((model) => HealthCondition(
      id: model.id,
      conditionName: model.conditionName,
      sugarLimit: model.sugarLimit,
      description: model.description,
    )).toList();
  }
}
