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
      id: map['id'] ?? 0,
      foodName: map['food_name'] ?? 'Unknown',
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      sugar: (map['sugar'] ?? 0).toDouble(),
      imagePath: map['image_path'] ?? '',
      createdAt:
          (map['date'] != null)
              ? DateTime.parse(map['date'])
              : (map['created_at'] != null)
              ? DateTime.parse(map['created_at'])
              : DateTime.now(),
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
