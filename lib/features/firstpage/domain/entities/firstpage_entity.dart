import 'package:equatable/equatable.dart';

class FirstpageEntity extends Equatable {
  final String gender;
  final double weight;
  final double height;
  final DateTime birthDate;
  final int activityId;
  final int healthId;

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  const FirstpageEntity({
    required this.gender,
    required this.weight,
    required this.height,
    required this.birthDate,
    required this.activityId,
    required this.healthId,
  });

  @override
  List<Object?> get props => [
    gender,
    weight,
    height,
    birthDate,
    activityId,
    healthId,
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
