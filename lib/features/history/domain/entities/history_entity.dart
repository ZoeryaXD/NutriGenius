import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final int id;
  final String foodName;
  final double calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? sugar;
  final String imagePath;
  final String mealType;
  final DateTime createdAt;

  const HistoryEntity({
    required this.id,
    required this.foodName,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.sugar,
    required this.imagePath,
    required this.mealType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, foodName, calories, createdAt];
}
