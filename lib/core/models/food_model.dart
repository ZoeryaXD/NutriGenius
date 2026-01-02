class FoodModel {
  final int? id;
  final int? journalId;
  final int? mealTypeId;
  final String foodName;
  final num calories;
  final num protein;
  final num carbs;
  final num fat;
  final num sugar;
  final String imagePath;
  final String createdAt;

  FoodModel({
    this.id,
    this.journalId,
    this.mealTypeId,
    required this.foodName,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.sugar = 0,
    required this.imagePath,
    required this.createdAt,
  });

  factory FoodModel.fromMap(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      journalId: json['journal_id'],
      mealTypeId: json['meal_type_id'],
      foodName: json['food_name'] ?? '',
      calories: _toNum(json['calories']),
      protein: _toNum(json['protein']),
      carbs: _toNum(json['carbs']),
      fat: _toNum(json['fat']),
      sugar: _toNum(json['sugar']),
      imagePath: json['image_url'] ?? json['image_path'] ?? '',
      createdAt: json['scan_timestamp'] ?? json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'journal_id': journalId,
      'meal_type_id': mealTypeId,
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

  static num _toNum(dynamic val) {
    if (val == null) return 0;
    if (val is String) return double.tryParse(val) ?? 0;
    return val;
  }
}
