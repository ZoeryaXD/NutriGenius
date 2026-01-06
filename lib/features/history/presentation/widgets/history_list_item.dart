import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/history_entity.dart';
import '../pages/detail_history_page.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryEntity item;
  final String userEmail;

  const HistoryListItem({
    super.key,
    required this.item,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "${ApiClient.baseUrl.replaceAll('/api', '')}/uploads/scans/${item.imagePath}";
    final dateStr = DateFormat('HH:mm').format(item.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder:
                (ctx, err, stack) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.broken_image,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
          ),
        ),
        title: Text(
          item.foodName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${item.calories} kkal • $dateStr"),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DetailHistoryPage(history: item, email: userEmail),
            ),
          );
        },
      ),
    );
  }
}
