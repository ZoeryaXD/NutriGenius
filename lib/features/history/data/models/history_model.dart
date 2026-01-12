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
    required super.mealType,
    required super.createdAt,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    String rawDate =
        map['created_at'] ??
        map['date'] ??
        map['scan_timestamp'] ??
        DateTime.now().toIso8601String();

    DateTime parsedDate = DateTime.parse(rawDate).toLocal();

    if (parsedDate.hour == 0 && parsedDate.minute == 0) {
      parsedDate = DateTime.now();
    }

    return HistoryModel(
      id: map['id'] ?? 0,
      foodName: map['food_name'] ?? map['foodName'] ?? 'Unknown',
      calories: (map['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (map['protein'] as num?)?.toDouble(),
      carbs: (map['carbs'] as num?)?.toDouble(),
      fat: (map['fat'] as num?)?.toDouble(),
      sugar: (map['sugar'] as num?)?.toDouble(),
      imagePath: map['image_path'] ?? map['imagePath'] ?? '',
      mealType: map['meal_name'] ?? map['meal_type'] ?? 'Umum',
      createdAt: parsedDate,
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
      'meal_type': mealType,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
