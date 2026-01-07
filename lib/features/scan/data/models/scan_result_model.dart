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

  factory ScanResultModel.fromJson(
    Map<String, dynamic> json,
    String imagePath,
  ) {
    print("🕵️ DEBUGGING MODEL:");
    print("👉 Keys yang tersedia: ${json.keys.toList()}");
    print("👉 Isi food_name: ${json['food_name']}");
    print("👉 Isi foodName: ${json['foodName']}");

    String finalName = "Tidak Diketahui";

    if (json['food_name'] != null && json['food_name'].toString().isNotEmpty) {
      finalName = json['food_name'];
    } else if (json['foodName'] != null &&
        json['foodName'].toString().isNotEmpty) {
      finalName = json['foodName'];
    } else if (json['name'] != null && json['name'].toString().isNotEmpty) {
      finalName = json['name'];
    } else if (json['food'] != null && json['food'].toString().isNotEmpty) {
      finalName = json['food'];
    } else if (json['FoodName'] != null &&
        json['FoodName'].toString().isNotEmpty) {
      finalName = json['FoodName'];
    }

    print("🔍 JSON DITERIMA DARI BACKEND: $json");
    return ScanResultModel(
      id: json['id'] ?? 0,
      foodName: finalName,

      calories: _toDouble(json['calories']),
      protein: _toDouble(json['protein']),
      carbs: _toDouble(json['carbs']),
      fat: _toDouble(json['fat']),
      sugar: _toDouble(json['sugar']),

      aiSuggestion:
          json['ai_suggestion'] ??
          json['aiSuggestion'] ??
          "Tidak ada saran dari AI.",
      imagePath: imagePath,
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
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'sugar': sugar,
      'aiSuggestion': aiSuggestion,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
    };
  }
}
