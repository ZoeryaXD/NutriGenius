import 'package:equatable/equatable.dart';

enum ScanSource { camera, gallery }

class ScanResult extends Equatable {
  final int id;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double sugar;
  final String imagePath;
  final String mealType;
  final String aiSuggestion;
  final DateTime createdAt;

  const ScanResult({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sugar,
    required this.imagePath,
    required this.mealType,
    required this.aiSuggestion,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    foodName,
    calories,
    protein,
    carbs,
    fat,
    sugar,
    imagePath,
    mealType,
    aiSuggestion,
    createdAt,
  ];
}
