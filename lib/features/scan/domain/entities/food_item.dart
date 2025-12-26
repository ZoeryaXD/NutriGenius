import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final int? id; // Nullable karena belum ada ID sebelum masuk database [cite: 215]
  final String foodName; // [cite: 218]
  final double calories; // [cite: 219]
  final double protein; // Data makro nutrisi (dari API AI)
  final double carbs;   // Data makro nutrisi
  final double fat;     // Data makro nutrisi
  final double sugar;   // Penting untuk fitur "Health Guard" (Diabetes) [cite: 43]
  final double portionSize; // Estimasi porsi (default 1.0) [cite: 220]
  final String? imagePath; // Lokasi file gambar di HP [cite: 221]

  const FoodItem({
    this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.sugar = 0.0, // Default 0 jika AI tidak mendeteksi gula
    this.portionSize = 1.0,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, foodName, calories, imagePath];
}