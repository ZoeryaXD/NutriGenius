import '../../domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
  ScanResultModel({
    super.id,
    required super.foodName,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    required super.sugar,
    required super.imagePath,
    required super.aiSuggestion,
    required super.date,
  });

  // Mapping dari JSON API Node.js
  factory ScanResultModel.fromJson(
    Map<String, dynamic> json,
    String localPath,
  ) {
    return ScanResultModel(
      foodName: json['food_name'] ?? 'Unknown',
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      imagePath: localPath,
      aiSuggestion: json['ai_suggestion'] ?? '',
      date: DateTime.now(),
    );
  }

  // Mapping untuk simpan ke SQLite
  Map<String, dynamic> toSqliteMap() {
    return {
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'sugar': sugar,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
    };
  }
}
