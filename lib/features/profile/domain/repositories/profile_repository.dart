import 'dart:io';
import '../entities/profile_entity.dart';
import '../entities/activity_level_entity.dart';
import '../entities/health_condition_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<void> updateProfile(ProfileEntity profile);
  Future<String> uploadPhoto(File imageFile);
  Future<void> deletePhoto();
  Future<void> deleteAccount();
  Future<void> logout();
  Future<void> changePassword(String newPassword);
  Future<List<HealthConditionEntity>> getHealthConditions();
  Future<List<ActivityLevelEntity>> getActivityLevels();
}
