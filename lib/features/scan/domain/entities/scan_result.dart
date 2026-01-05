class ScanResult {
  final int? id;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double sugar;
  final String imagePath; // Lokasi file di penyimpanan lokal HP
  final String aiSuggestion;
  final DateTime date;

  ScanResult({
    this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sugar,
    required this.imagePath,
    required this.aiSuggestion,
    required this.date,
  });
}
