import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/history_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryEntity food;
  final String email;

  const DetailHistoryPage({super.key, required this.food, required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final String formattedDate = DateFormat(
      'dd MMM yyyy, HH:mm',
      'id_ID',
    ).format(food.createdAt);

    String imageUrl = food.imagePath;
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      final String cleanBaseUrl = ApiClient.baseUrl.replaceAll('/api', '');
      imageUrl = "$cleanBaseUrl/uploads/scans/${food.imagePath}";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Nutrisi",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child:
              isLandscape
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: _buildImage(imageUrl, theme),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                          child: _buildDetails(context, formattedDate, theme),
                        ),
                      ),
                    ],
                  )
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImage(imageUrl, theme),
                        const SizedBox(height: 24),
                        _buildDetails(context, formattedDate, theme),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.3 : 0.08,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child:
            imageUrl.isEmpty
                ? Container(
                  height: 300,
                  width: double.infinity,
                  color: theme.colorScheme.surface,
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                )
                : Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (ctx, err, stack) => Container(
                        height: 300,
                        color: theme.colorScheme.surface,
                        child: const Icon(Icons.broken_image_rounded, size: 64),
                      ),
                ),
      ),
    );
  }

  Widget _buildDetails(
    BuildContext context,
    String formattedDate,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          food.foodName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Dicatat pada $formattedDate",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(thickness: 1.2),
        ),
        _buildRow(
          "Energi / Kalori",
          "${food.calories.toStringAsFixed(1)} kcal",
          const Color(0xFF2E7D32),
          theme,
          isBold: true,
        ),
        _buildRow(
          "Protein",
          "${(food.protein ?? 0.0).toStringAsFixed(1)} g",
          const Color(0xFF1976D2),
          theme,
        ),
        _buildRow(
          "Karbohidrat",
          "${(food.carbs ?? 0.0).toStringAsFixed(1)} g",
          const Color(0xFFF57C00),
          theme,
        ),
        _buildRow(
          "Lemak Total",
          "${(food.fat ?? 0.0).toStringAsFixed(1)} g",
          const Color(0xFF7B1FA2),
          theme,
        ),
        _buildRow(
          "Gula",
          "${(food.sugar ?? 0.0).toStringAsFixed(1)} g",
          const Color(0xFFC2185B),
          theme,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => _showDelete(context),
            child: const Text(
              "Hapus Data Riwayat",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color valueColor,
    ThemeData theme, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              "Hapus Riwayat?",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            content: const Text(
              "Data yang dihapus tidak dapat dipulihkan kembali.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<HistoryBloc>().add(
                    DeleteHistoryEvent(id: food.id, email: email),
                  );
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
