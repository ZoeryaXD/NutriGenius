import 'package:equatable/equatable.dart';
import '../../domain/entities/firstpage_entity.dart';

enum FirstPageStatus {
  initial,
  loadingMaster,
  successMaster,
  calculating,
  success,
  successSubmit,
  failure,
}

class FirstPageState extends Equatable {
  final String gender;
  final double weight, height, bmr, tdee;
  final DateTime? birthDate;
  final int activityId, healthId;
  final FirstPageStatus status;
  final String? error;

  final List<ActivityLevel> activityLevels;
  final List<HealthCondition> healthConditions;

  const FirstPageState({
    this.gender = '-',
    this.weight = 0,
    this.height = 0,
    this.bmr = 0,
    this.tdee = 0,
    this.birthDate,
    this.activityId = 1,
    this.healthId = 1,
    this.status = FirstPageStatus.initial,
    this.error,
    this.activityLevels = const [],
    this.healthConditions = const [],
  });

  FirstPageState copyWith({
    String? gender,
    double? weight,
    double? height,
    double? bmr,
    double? tdee,
    DateTime? birthDate,
    int? activityId,
    int? healthId,
    FirstPageStatus? status,
    String? error,
    List<ActivityLevel>? activityLevels,
    List<HealthCondition>? healthConditions,
  }) {
    return FirstPageState(
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      birthDate: birthDate ?? this.birthDate,
      activityId: activityId ?? this.activityId,
      healthId: healthId ?? this.healthId,
      status: status ?? this.status,
      error: error ?? this.error,
      activityLevels: activityLevels ?? this.activityLevels,
      healthConditions: healthConditions ?? this.healthConditions,
    );
  }

  @override
  List<Object?> get props => [
    gender,
    weight,
    height,
    bmr,
    tdee,
    birthDate,
    activityId,
    healthId,
    status,
    error,
    activityLevels,
    healthConditions,
  ];
}
