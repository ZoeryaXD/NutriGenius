import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String displayName;
  final String email;
  final String healthCondition;
  final double tdee;
  final double caloriesConsumed;
  final double caloriesRemaining;
  final int caloriesPercentage;
  final int scanCountToday;
  final double proteinTarget;
  final double proteinConsumed;
  final double proteinRemaining;
  final int proteinPercentage;
  final double carbsTarget;
  final double carbsConsumed;
  final double carbsRemaining;
  final int carbsPercentage;
  final double fatTarget;
  final double fatConsumed;
  final double fatRemaining;
  final int fatPercentage;
  final double sugarConsumed;

  double get progress => (tdee == 0) ? 0 : (caloriesConsumed / tdee);

  const DashboardEntity({
    required this.displayName,
    required this.email,
    required this.healthCondition,
    required this.tdee,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.caloriesPercentage,
    required this.scanCountToday,
    required this.proteinTarget,
    required this.proteinConsumed,
    required this.proteinRemaining,
    required this.proteinPercentage,
    required this.carbsTarget,
    required this.carbsConsumed,
    required this.carbsRemaining,
    required this.carbsPercentage,
    required this.fatTarget,
    required this.fatConsumed,
    required this.fatRemaining,
    required this.fatPercentage,
    required this.sugarConsumed,
  });

  @override
  List<Object?> get props => [
    displayName,
    email,
    healthCondition,
    tdee,
    caloriesConsumed,
    caloriesRemaining,
    caloriesPercentage,
    scanCountToday,
    proteinTarget,
    proteinConsumed,
    proteinRemaining,
    proteinPercentage,
    carbsTarget,
    carbsConsumed,
    carbsRemaining,
    carbsPercentage,
    fatTarget,
    fatConsumed,
    fatRemaining,
    fatPercentage,
    sugarConsumed,
  ];
}
