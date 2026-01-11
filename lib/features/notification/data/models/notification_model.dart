import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  
  NotificationModel({
    required super.id, // ID wajib ada
    required super.title,
    required super.body,
    required super.icon,
    required super.color,
    required super.category,
    super.isRead,
    required super.timestamp,
  });

  // Factory Method: Pura-pura siap menerima JSON dari Backend
  // (Ini poin plus saat presentasi: "Kode ini sudah support JSON parsing")
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'Notifikasi Baru',
      body: json['body'] ?? '',
      
      // Logika pemetaan Icon & Warna dari String kategori
      icon: _getIconByCategory(json['category']),
      color: _getColorByCategory(json['category']),
      
      category: json['category'] ?? 'system',
      isRead: json['is_read'] ?? false,
      timestamp: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  // --- Helper Functions (Supaya rapi) ---
  
  static IconData _getIconByCategory(String? category) {
    switch (category) {
      case 'reminder':
        return Icons.access_alarm;
      case 'motivation':
        return Icons.emoji_events;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  static Color _getColorByCategory(String? category) {
    switch (category) {
      case 'reminder':
        return Colors.orange;
      case 'motivation':
        return Colors.teal;
      case 'system':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}