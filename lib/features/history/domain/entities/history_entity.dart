class HistoryEntity {
  final int? id;
  final String foodName;
  final double calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? sugar;
  final String? imagePath;
  final String createdAt;

  HistoryEntity({
    this.id,
    required this.foodName,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.sugar,
    this.imagePath,
    required this.createdAt,
  });
}
