import '../../domain/entities/history_entity.dart';

class HistoryModel extends HistoryEntity {
  HistoryModel({
    super.id,
    required super.foodName,
    required super.calories,
    super.protein,
    super.carbs,
    super.fat,
    super.sugar,
    super.imagePath,
    required super.createdAt,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> json) => HistoryModel(
    id: json['id'],
    foodName: json['food_name'],
    calories: json['calories'].toDouble(),
    protein: json['protein']?.toDouble(),
    carbs: json['carbs']?.toDouble(),
    fat: json['fat']?.toDouble(),
    sugar: json['sugar']?.toDouble(),
    imagePath: json['image_path'],
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'food_name': foodName,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'sugar': sugar,
    'image_path': imagePath,
    'created_at': createdAt,
  };
}
