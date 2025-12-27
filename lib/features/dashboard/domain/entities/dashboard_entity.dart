import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String displayName;
  final double tdee; 
  final double caloriesConsumed; 
  
  int get remainingCalories => (tdee - caloriesConsumed).toInt();
  
  // Update Rumus Makro (Standard Balanced Diet)
  // Protein (1g = 4kkal) -> 25% dari total kalori
  // Carbs (1g = 4kkal) -> 50% dari total kalori
  // Fat (1g = 9kkal) -> 25% dari total kalori
  // Kamu bisa sesuaikan persentase ini sesuai saran ahli gizi di proposalmu
  int get proteinTarget => ((tdee * 0.25) / 4).round();
  int get carbsTarget => ((tdee * 0.50) / 4).round();
  int get fatTarget => ((tdee * 0.25) / 9).round();

  // Progress Bar (0.0 sampai 1.0)
  // Jika caloriesConsumed 0, progress 0.
  double get progress {
    if (tdee == 0) return 0;
    double p = caloriesConsumed / tdee;
    return p > 1.0 ? 1.0 : p; // Jangan lebih dari 100%
  }

  const DashboardEntity({
    required this.displayName,
    required this.tdee,
    this.caloriesConsumed = 0,
  });

  @override
  List<Object?> get props => [displayName, tdee, caloriesConsumed];
}