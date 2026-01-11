import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrigenius/features/profile/presentation/pages/profile_page.dart';
import 'notification_page.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationItem item;

  const NotificationDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String formattedDate = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(item.timestamp);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Detail Notifikasi"),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Hero(
              tag: 'icon_${item.timestamp}',
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 44),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.category.toUpperCase(),
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              formattedDate,
              style: TextStyle(color: theme.hintColor, fontSize: 14),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Divider(height: 1),
            ),
            Text(
              item.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: isDark ? Colors.grey[300] : Colors.black87,
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _handleNavigation(context, item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Lakukan Sekarang",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, NotificationItem item) {
    final String titleLower = item.title.toLowerCase();

    if (titleLower.contains('profil') || titleLower.contains('lengkap')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (titleLower.contains('laporan') ||
        titleLower.contains('history')) {
      Navigator.pushNamed(context, '/history');
    } else if (titleLower.contains('makan') ||
        titleLower.contains('sarapan') ||
        titleLower.contains('scan')) {
      Navigator.pushNamed(context, '/scan');
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    }
  }
}
