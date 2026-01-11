import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationRemoteDataSource {
  
  static const String _keyRead = 'read_notifications';
  static const String _keyDeleted = 'deleted_notifications';

  Future<List<NotificationEntity>> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> readList = prefs.getStringList(_keyRead) ?? [];
    final List<String> deletedList = prefs.getStringList(_keyDeleted) ?? [];

    await Future.delayed(const Duration(milliseconds: 500)); 

    final now = DateTime.now();
    
    final String todayStr = "${now.year}-${now.month}-${now.day}";
    
    List<NotificationEntity> rawData = [];
    final random = Random();

    if (now.hour >= 6 && now.hour < 10) {
      rawData.add(NotificationEntity(
        id: 'reminder_breakfast_$todayStr', 
        title: "Waktunya Sarapan! 🍳",
        body: "Awali harimu dengan energi. Jangan lupa catat sarapanmu ya!",
        icon: Icons.wb_sunny,
        color: Colors.orange,
        category: 'reminder',
        timestamp: now.subtract(const Duration(minutes: 10)),
      ));
    } else if (now.hour >= 11 && now.hour < 14) {
      rawData.add(NotificationEntity(
        id: 'reminder_lunch_$todayStr', 
        title: "Waktunya Makan Siang 🥗",
        body: "Ingat komposisi piring sehat: Karbohidrat, Protein, dan Serat.",
        icon: Icons.lunch_dining,
        color: Colors.green,
        category: 'reminder',
        timestamp: now.subtract(const Duration(minutes: 15)),
      ));
    } else if (now.hour >= 17 && now.hour < 21) {
      rawData.add(NotificationEntity(
        id: 'reminder_dinner_$todayStr',
        title: "Waktunya Makan Malam 🍽️",
        body: "Hindari makan terlalu larut agar kualitas tidurmu tetap terjaga.",
        icon: Icons.nightlight_round,
        color: Colors.indigo,
        category: 'reminder',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ));
    }

    rawData.add(NotificationEntity(
      id: 'reminder_water_$todayStr',
      title: "Sudah Minum Air? 💧",
      body: "Jaga hidrasi tubuhmu. Minum segelas air sekarang.",
      icon: Icons.local_drink,
      color: Colors.blue,
      category: 'reminder',
      timestamp: now.subtract(const Duration(minutes: 45)),
    ));

    rawData.add(NotificationEntity(
      id: 'motivation_$todayStr', 
      title: "Motivasi Hari Ini ✨",
      body: "Kesehatan adalah investasi terbaik untuk masa depanmu.", 
      icon: Icons.emoji_events,
      color: Colors.amber,
      category: 'motivation',
      timestamp: now.subtract(const Duration(hours: 2)),
    ));

    rawData.add(NotificationEntity(
      id: 'tips_$todayStr',
      title: "Tips Tidur 😴",
      body: "Matikan gadget 30 menit sebelum tidur untuk kualitas istirahat.",
      icon: Icons.lightbulb,
      color: Colors.teal,
      category: 'system',
      timestamp: now.subtract(const Duration(hours: 4)),
    ));

    rawData.add(NotificationEntity(
      id: 'system_profile_$todayStr', 
      title: "Lengkapi Profil Anda 👤",
      body: "Pastikan data berat dan tinggi badanmu terbaru.",
      icon: Icons.person_search,
      color: Colors.orangeAccent,
      category: 'system',
      timestamp: now.subtract(const Duration(days: 1)),
    ));
    
    List<NotificationEntity> finalData = [];

    for (var item in rawData) {
      if (deletedList.contains(item.id)) {
        continue; 
      }

      if (readList.contains(item.id)) {
        item.isRead = true; 
      }

      finalData.add(item);
    }

    finalData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return finalData;
  }

  Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readList = prefs.getStringList(_keyRead) ?? [];
    if (!readList.contains(id)) {
      readList.add(id);
      await prefs.setStringList(_keyRead, readList);
    }
  }

  Future<void> deleteItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> deletedList = prefs.getStringList(_keyDeleted) ?? [];
    if (!deletedList.contains(id)) {
      deletedList.add(id);
      await prefs.setStringList(_keyDeleted, deletedList);
    }
  }

  Future<void> deleteAll(List<String> currentIds) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> deletedList = prefs.getStringList(_keyDeleted) ?? [];
    
    for (var id in currentIds) {
      if (!deletedList.contains(id)) {
        deletedList.add(id);
      }
    }
    await prefs.setStringList(_keyDeleted, deletedList);
  }
}