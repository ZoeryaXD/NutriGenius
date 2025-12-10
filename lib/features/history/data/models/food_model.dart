class FoodModel {
  final int? id;
  final String foodName;
  final num calories;
  final String imagePath;
  final String createdAt;

  FoodModel({
    this.id,
    required this.foodName,
    required this.calories,
    required this.imagePath,
    required this.createdAt,
  });

  factory FoodModel.fromMap(Map<String, dynamic> json) => FoodModel(
    id: json['id'],
    foodName: json['food_name'],
    calories: json['calories'],
    imagePath: json['image_path'] ?? '',
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food_name': foodName,
      'calories': calories,
      'image_path': imagePath,
      'created_at': createdAt,
    };
  }
}
