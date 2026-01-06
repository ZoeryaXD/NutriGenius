import '../../domain/entities/history_entity.dart';

class HistoryModel extends HistoryEntity {
  const HistoryModel({
    required super.id,
    required super.foodName,
    required super.calories,
    super.protein,
    super.carbs,
    super.fat,
    super.sugar,
    required super.imagePath,
    required super.createdAt,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      foodName: map['food_name'] ?? 'Unknown',
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num?)?.toDouble(),
      carbs: (map['carbs'] as num?)?.toDouble(),
      fat: (map['fat'] as num?)?.toDouble(),
      sugar: (map['sugar'] as num?)?.toDouble(),
      imagePath: map['image_path'] ?? '',
      createdAt: DateTime.parse(map['created_at']), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food_name': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'sugar': sugar,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(), 
    };
  }
}