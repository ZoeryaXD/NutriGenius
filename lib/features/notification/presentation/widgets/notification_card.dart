import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Logika warna: abu-abu jika sudah dibaca, putih jika belum
    final bgColor = item.isRead ? Colors.grey[50] : Colors.white;
    // Border: transparan jika sudah dibaca
    final borderColor = item.isRead ? Colors.transparent : item.color.withOpacity(0.3);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: item.isRead
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap, // Aksi saat diklik
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Icon Bulat ---
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.isRead ? Colors.grey[200] : item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isRead ? Colors.grey : item.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // --- Teks Konten ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: item.isRead ? Colors.grey[700] : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // --- Jam (Timestamp) ---
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 10, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            "${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(color: Colors.grey[400], fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- Titik Merah (Indikator Belum Dibaca) ---
                if (!item.isRead)
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 8),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}