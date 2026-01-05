import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/history_entity.dart';
import '../pages/detail_history_page.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryEntity food;
  const HistoryListItem({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailHistoryPage(food: food),
              ),
            ),
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              food.imagePath != null &&
                      food.imagePath!.isNotEmpty &&
                      File(food.imagePath!).existsSync()
                  ? Image.file(
                    File(food.imagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                  : Container(
                    width: 60,
                    height: 60,
                    color: Colors.green[50],
                    child: const Icon(Icons.fastfood, color: Colors.green),
                  ),
        ),
        title: Text(
          food.foodName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${food.calories.toStringAsFixed(0)} kkal",
          style: const TextStyle(color: Color(0xFF2E7D32)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
