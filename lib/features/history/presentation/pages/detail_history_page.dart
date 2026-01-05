import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrigenius/features/history/domain/entities/history_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryEntity food;
  const DetailHistoryPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    try {
      DateTime dateTime = DateTime.parse(food.createdAt);
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      formattedDate = food.createdAt;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          food.foodName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child:
                  food.imagePath != null &&
                          food.imagePath!.isNotEmpty &&
                          File(food.imagePath!).existsSync()
                      ? Image.file(
                        File(food.imagePath!),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.green[50],
                        child: const Icon(
                          Icons.fastfood,
                          size: 100,
                          color: Colors.green,
                        ),
                      ),
            ),
            const SizedBox(height: 24),

            Text(
              food.foodName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "Dicatat pada: $formattedDate",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 40, thickness: 1),

            const Text(
              "Rincian Nutrisi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildNutrientRow(
              "Kalori Total",
              "${food.calories.toStringAsFixed(1)} kkal",
              isPrimary: true,
            ),
            _buildNutrientRow(
              "Protein",
              "${(food.protein ?? 0.0).toStringAsFixed(1)} g",
            ),
            _buildNutrientRow(
              "Karbohidrat",
              "${(food.carbs ?? 0.0).toStringAsFixed(1)} g",
            ),
            _buildNutrientRow(
              "Lemak",
              "${(food.fat ?? 0.0).toStringAsFixed(1)} g",
            ),
            _buildNutrientRow(
              "Gula",
              "${(food.sugar ?? 0.0).toStringAsFixed(1)} g",
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                label: const Text(
                  "Hapus Riwayat",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(
    String label,
    String value, {
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFE8F5E9) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPrimary ? const Color(0xFF2E7D32) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Data?"),
            content: const Text(
              "Apakah Anda yakin ingin menghapus riwayat ini? Data di perangkat dan server akan dihapus.",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<HistoryBloc>().add(DeleteHistory(food.id!));

                  Navigator.pop(context);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Riwayat berhasil dihapus"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
