import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String fullName;
  final String email;
  final String? profilePicture;
  final String gender;
  final DateTime birthDate;
  final double weight;
  final double height;
  final int age;
  final int healthId;
  final int activityId;

  const ProfileEntity({
    required this.fullName,
    required this.email,
    this.profilePicture,
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.age,
    required this.healthId,
    required this.activityId,
  });

  @override
  List<Object?> get props => [
    email,
    fullName,
    profilePicture,
    gender,
    birthDate,
    weight,
    height,
    age,
    healthId,
    activityId,
  ];
}

class ActivityLevel extends Equatable {
  final int id;
  final String levelName;
  final double multiplier;
  final String description;

  const ActivityLevel({
    required this.id,
    required this.levelName,
    required this.multiplier,
    required this.description,
  });

  @override
  List<Object?> get props => [id, levelName, multiplier, description];
}

class HealthCondition extends Equatable {
  final int id;
  final String conditionName;
  final double sugarLimit;
  final String description;

  const HealthCondition({
    required this.id,
    required this.conditionName,
    required this.sugarLimit,
    required this.description,
  });

  @override
  List<Object?> get props => [id, conditionName, sugarLimit, description];
}
