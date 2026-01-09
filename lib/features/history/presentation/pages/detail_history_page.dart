import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/history_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryEntity history;
  final String email;

  const DetailHistoryPage({
    super.key,
    required this.history,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "${ApiClient.baseUrl.replaceAll('/api', '')}/uploads/scans/${history.imagePath}";
    final formattedDate = DateFormat(
      'EEEE, d MMM yyyy • HH:mm',
      'id_ID',
    ).format(history.createdAt);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.green,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (ctx, err, stack) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.green),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onPressed: () => _showDeleteConfirm(context),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    history.foodName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Informasi Nutrisi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildNutrientCard(
                        "🔥 Kalori",
                        "${history.calories} kkal",
                        Colors.orange,
                      ),
                      _buildNutrientCard(
                        "🥩 Protein",
                        "${history.protein ?? 0}g",
                        Colors.blue,
                      ),
                      _buildNutrientCard(
                        "🍞 Karbo",
                        "${history.carbs ?? 0}g",
                        Colors.brown,
                      ),
                      _buildNutrientCard(
                        "🥑 Lemak",
                        "${history.fat ?? 0}g",
                        Colors.yellow[800]!,
                      ),
                      _buildNutrientCard(
                        "🍬 Gula",
                        "${history.sugar ?? 0}g",
                        Colors.pink,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Riwayat?"),
            content: const Text("Data ini akan hilang permanen."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  context.read<HistoryBloc>().add(
                    DeleteHistoryEvent(id: history.id, email: email),
                  );
                  Navigator.pop(ctx);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data berhasil dihapus"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
