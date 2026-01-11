import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  
  NotificationModel({
    required super.id, 
    required super.title,
    required super.body,
    required super.icon,
    required super.color,
    required super.category,
    super.isRead,
    required super.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'Notifikasi Baru',
      body: json['body'] ?? '',
      
      icon: _getIconByCategory(json['category']),
      color: _getColorByCategory(json['category']),
      
      category: json['category'] ?? 'system',
      isRead: json['is_read'] ?? false,
      timestamp: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
  
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