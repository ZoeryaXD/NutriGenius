import '../../domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
   ScanResultModel({
    required int id,
    required String foodName,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double sugar,
    required String aiSuggestion,
    required String imagePath,
    required DateTime date,
  }) : super(
         id: id,
         foodName: foodName,
         calories: calories,
         protein: protein,
         carbs: carbs,
         fat: fat,
         sugar: sugar,
         aiSuggestion: aiSuggestion,
         imagePath: imagePath,
         date: date,
       );

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] ?? 0,
      foodName: json['food_name'] ?? 'Tidak Diketahui',

      calories: _toDouble(json['calories']),
      protein: _toDouble(json['protein']),
      carbs: _toDouble(json['carbs']),
      fat: _toDouble(json['fat']),
      sugar: _toDouble(json['sugar']),

      aiSuggestion: json['ai_suggestion'] ?? '',
      imagePath: json['image_path'] ?? '',

      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is int) return val.toDouble();
    if (val is double) return val;
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'food_name': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'sugar': sugar,
      'ai_suggestion': aiSuggestion,
      'image_path': imagePath,
      'date': date.toIso8601String(),
    };
  }
}
