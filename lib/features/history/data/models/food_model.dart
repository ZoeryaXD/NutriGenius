class FoodModel {
  final int? id;
  final String foodName;
  final num calories;
  final String imagePath;
  final String createdAt;
  final int isSynced;

  FoodModel({
    this.id,
    required this.foodName,
    required this.calories,
    required this.imagePath,
    required this.createdAt,
    this.isSynced = 0,
  });

  factory FoodModel.fromMap(Map<String, dynamic> json) => FoodModel(
    id: json['id'],
    foodName: json['food_name'],
    calories: json['calories'],
    imagePath: json['image_path'] ?? '',
    createdAt: json['created_at'],
    isSynced: json['is_synced'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'food_name': foodName,
    'calories': calories,
    'image_path': imagePath,
    'created_at': createdAt,
    'is_synced': isSynced,
  };
}
