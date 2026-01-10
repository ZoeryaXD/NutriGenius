import 'package:flutter/material.dart';
import 'dart:math';
import 'notification_detail_page.dart';

// --- MODEL DATA NOTIFIKASI ---
class NotificationItem {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final String category; // 'reminder', 'motivation', 'system', 'water', 'workout'
  bool isRead;
  final DateTime timestamp;

  NotificationItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    required this.category,
    this.isRead = false,
    required this.timestamp,
  });
}

List<NotificationItem> _fakeDatabase = [];

bool _hasInitialized = false; 

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Color primaryGreen = const Color(0xFF2E7D32);
  
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    if (!_hasInitialized) {
      final now = DateTime.now();
      List<NotificationItem> generatedList = [];

      // --- 1. MINUM AIR ---
      generatedList.add(NotificationItem(
        title: "Waktunya Minum Air! 💧",
        body: "Sudah minum gelas ke-4 hari ini? Tetap terhidrasi agar metabolisme lancar.",
        icon: Icons.local_drink,
        color: Colors.blueAccent,
        category: 'reminder',
        timestamp: now.subtract(const Duration(minutes: 15)),
      ));

      // --- 2. JADWAL OLAHRAGA ---
      int currentHour = now.hour;
      if (currentHour >= 5 && currentHour < 10) {
        generatedList.add(NotificationItem(
          title: "Olahraga Pagi Yuk! 🏃‍♂️",
          body: "Mulai harimu dengan Jogging 15 menit atau Yoga ringan untuk energi maksimal.",
          icon: Icons.directions_run,
          color: Colors.orange,
          category: 'motivation',
          timestamp: now,
        ));
      } 
      else if (currentHour >= 11 && currentHour < 15) {
        generatedList.add(NotificationItem(
          title: "Waktunya Stretching Siang 🧘",
          body: "Badan pegal duduk terus? Lakukan peregangan 5 menit agar tidak kaku.",
          icon: Icons.accessibility_new,
          color: Colors.teal,
          category: 'motivation',
          timestamp: now,
        ));
      } 
      else if (currentHour >= 15 && currentHour < 21) {
        generatedList.add(NotificationItem(
          title: "Jadwal Workout Sore 💪",
          body: "Saatnya bakar kalori! Angkat beban atau Cardio intensif sepulang aktivitas.",
          icon: Icons.fitness_center,
          color: Colors.redAccent,
          category: 'motivation',
          timestamp: now,
        ));
      }

      generatedList.add(NotificationItem(
        title: "Lengkapi Profil Anda 👤",
        body: "Silahkan lengkapi informasi profil untuk pengalaman yang lebih personal.",
        icon: Icons.person_search,
        color: Colors.purple,
        category: 'system',
        timestamp: now.subtract(const Duration(days: 1)),
      ));

      if (currentHour >= 6 && currentHour < 10) {
        generatedList.add(NotificationItem(
          title: "Sarapan Sehat 🍳",
          body: "Jangan lewatkan sarapan. Sudah log makananmu?",
          icon: Icons.wb_sunny,
          color: Colors.orangeAccent,
          category: 'reminder',
          timestamp: now.subtract(const Duration(minutes: 5)),
        ));
      } else if (currentHour >= 11 && currentHour < 14) {
        generatedList.add(NotificationItem(
          title: "Waktunya Makan Siang 🥗",
          body: "Ingat, porsi sayuran harus lebih banyak dari karbohidrat!",
          icon: Icons.lunch_dining,
          color: Colors.green,
          category: 'reminder',
          timestamp: now.subtract(const Duration(minutes: 5)),
        ));
      } else if (currentHour >= 17 && currentHour < 21) {
        generatedList.add(NotificationItem(
          title: "Makan Malam Ringan 🍽️",
          body: "Hindari makanan berat sebelum tidur ya.",
          icon: Icons.nightlight_round,
          color: Colors.indigo,
          category: 'reminder',
          timestamp: now.subtract(const Duration(minutes: 5)),
        ));
      }

      final quotes = [
        "Tubuhmu adalah aset terbaikmu.",
        "Rasa sakit hari ini adalah kekuatan bagi esok hari.",
        "Jangan berhenti saat lelah, berhentilah saat selesai.",
      ];
      generatedList.add(NotificationItem(
        title: "Motivasi Hari Ini ✨",
        body: quotes[Random().nextInt(quotes.length)],
        icon: Icons.emoji_events,
        color: Colors.amber,
        category: 'motivation',
        timestamp: now.subtract(const Duration(hours: 4)),
      ));

      generatedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      _fakeDatabase = generatedList;
      
      _hasInitialized = true;
    }

    if (mounted) {
      setState(() {
        _notifications = _fakeDatabase;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
     await Future.delayed(const Duration(seconds: 1));
     setState(() {}); 
  }

  void _onNotificationTap(NotificationItem item) {
    setState(() {
      item.isRead = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifikasi",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cleaning_services_outlined),
                      color: Colors.grey,
                      tooltip: "Hapus Semua Notifikasi",
                      onPressed: () {
                        setState(() {
                          _fakeDatabase.clear(); 
                          _notifications.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Semua notifikasi telah dihapus."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        // Catatan: _hasInitialized TETAP TRUE. 
                        // Jadi saat kembali nanti, dia tidak akan generate ulang.
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(
                                  "Tidak ada notifikasi baru", 
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              return _buildNotificationCard(_notifications[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    final bgColor = item.isRead ? Colors.grey[50] : Colors.white;
    final borderColor = item.isRead ? Colors.grey[300]! : item.color.withOpacity(0.5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: item.isRead ? 1 : 1.5),
        boxShadow: item.isRead
            ? [] 
            : [
                BoxShadow(
                  color: item.color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _onNotificationTap(item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.isRead ? Colors.grey[200] : item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.isRead ? Colors.grey : item.color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 14,
                          color: item.isRead ? Colors.grey[600] : Colors.black87,
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