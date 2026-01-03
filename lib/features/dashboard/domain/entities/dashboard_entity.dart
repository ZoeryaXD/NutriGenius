import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String displayName;
  final double tdee; 
  final double caloriesConsumed; 
  final double proteinTarget, proteinConsumed; 
  final double carbsTarget, carbsConsumed; 
  final double fatTarget, fatConsumed;
  
  int get remainingCalories => (tdee - caloriesConsumed).toInt();
  double get progress => (tdee == 0) ? 0 : (caloriesConsumed / tdee);

 const DashboardEntity({
    required this.displayName,
    required this.tdee,
    this.caloriesConsumed = 0,
    required this.proteinTarget,
    this.proteinConsumed = 0,
    required this.carbsTarget,
    this.carbsConsumed = 0,
    required this.fatTarget,
    this.fatConsumed = 0,
  });

  @override
  List<Object?> get props => [displayName, tdee, caloriesConsumed];
}