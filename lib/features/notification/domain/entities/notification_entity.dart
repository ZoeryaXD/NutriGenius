import 'package:flutter/material.dart';

class NotificationEntity {
  final String id; 
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final String category;
  bool isRead;
  final DateTime timestamp;

  NotificationEntity({
    required this.id, 
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    required this.category,
    this.isRead = false,
    required this.timestamp,
  });
}