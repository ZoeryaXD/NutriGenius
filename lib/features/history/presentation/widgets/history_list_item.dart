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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String finalImageUrl = item.imagePath;
    if (finalImageUrl.isNotEmpty && !finalImageUrl.startsWith('http')) {
      final String cleanBaseUrl = ApiClient.baseUrl.replaceAll('/api', '');
      finalImageUrl = "$cleanBaseUrl/uploads/scans/${item.imagePath}";
    }

    final dateStr = DateFormat('HH:mm').format(item.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              finalImageUrl.isEmpty
                  ? Container(
                    width: 48,
                    height: 48,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  )
                  : Image.network(
                    finalImageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 48,
                          height: 48,
                          color: theme.disabledColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.broken_image_rounded,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                  ),
        ),
        title: Text(
          item.foodName,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${item.calories.toInt()} kcal - $dateStr",
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
          size: 18,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DetailHistoryPage(food: item, email: userEmail),
            ),
          );
        },
      ),
    );
  }
}
