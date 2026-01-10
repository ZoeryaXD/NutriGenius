import 'dart:io';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<void> updateProfile(ProfileEntity profile);
  Future<String> uploadPhoto(File imageFile);
  Future<void> deletePhoto();
  Future<void> deleteAccount();
  Future<void> logout();

  Future<List<ActivityLevel>> getActivityLevels();
  Future<List<HealthCondition>> getHealthConditions();
}