import '../entities/firstpage_entity.dart';

abstract class FirstPageRepository {
  Future<void> submitProfile({
    required String email,
    required String gender,
    required DateTime birthDate,
    required double weight,
    required double height,
    required int activityId,
    required int healthId,
    required double bmr,
    required double tdee,
  });

  Future<List<ActivityLevel>> getActivityLevels();
  Future<List<HealthCondition>> getHealthConditions();
}