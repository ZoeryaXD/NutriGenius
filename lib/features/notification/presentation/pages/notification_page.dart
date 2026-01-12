import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'notification_detail_page.dart';

class NotificationItem {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final String category;
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
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (mounted) setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_hasInitialized) {
      final now = DateTime.now();
      List<NotificationItem> generatedList = [
        NotificationItem(
          title: "Waktunya Minum Air! 💧",
          body:
              "Sudah minum gelas ke-4 hari ini? Tetap terhidrasi agar metabolisme lancar.",
          icon: Icons.local_drink_rounded,
          color: Colors.blueAccent,
          category: 'reminder',
          timestamp: now.subtract(const Duration(minutes: 15)),
        ),
        NotificationItem(
          title: "Lengkapi Profil Anda 👤",
          body:
              "Silahkan lengkapi informasi profil untuk pengalaman yang lebih personal.",
          icon: Icons.person_search_rounded,
          color: Colors.purple,
          category: 'system',
          timestamp: now.subtract(const Duration(days: 1)),
        ),
      ];

      final quotes = [
        "Tubuhmu adalah aset terbaikmu.",
        "Rasa sakit hari ini adalah kekuatan esok.",
        "Jangan berhenti saat lelah.",
      ];
      generatedList.add(
        NotificationItem(
          title: "Motivasi Hari Ini ✨",
          body: quotes[Random().nextInt(quotes.length)],
          icon: Icons.emoji_events_rounded,
          color: Colors.amber[700]!,
          category: 'motivation',
          timestamp: now.subtract(const Duration(hours: 4)),
        ),
      );

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

  void _onNotificationTap(NotificationItem item) {
    setState(() => item.isRead = true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadNotifications,
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (_notifications.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_sweep_outlined),
                        onPressed: () {
                          setState(() {
                            _fakeDatabase.clear();
                            _notifications.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _notifications.isEmpty
                        ? _buildEmptyState(theme)
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _notifications.length,
                          itemBuilder:
                              (context, index) => _buildNotificationCard(
                                _notifications[index],
                                theme,
                              ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 80,
            color: theme.hintColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "Tidak ada notifikasi baru",
            style: TextStyle(color: theme.hintColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.transparent : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              item.isRead
                  ? colorScheme.outlineVariant.withOpacity(0.5)
                  : item.color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => _onNotificationTap(item),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight:
                            item.isRead ? FontWeight.w500 : FontWeight.bold,
                        fontSize: 15,
                        color:
                            item.isRead
                                ? theme.hintColor
                                : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('HH:mm').format(item.timestamp),
                      style: TextStyle(color: theme.hintColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}