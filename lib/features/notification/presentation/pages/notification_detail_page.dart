import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrigenius/features/profile/presentation/pages/profile_page.dart';
import 'notification_page.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationItem item;

  const NotificationDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(item.timestamp);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Notifikasi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [

            Hero(
              tag: 'icon_${item.timestamp}',
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Icon(item.icon, color: item.color, size: 40),
                ),
              ),
            ),

            const SizedBox(height: 16),
            
            Chip(
              label: Text(
                item.category.toUpperCase(),
                style: TextStyle(color: item.color, fontWeight: FontWeight.bold),
              ),
              backgroundColor: item.color.withOpacity(0.05),
              side: BorderSide.none,
            ),
            const SizedBox(height: 32),

            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            
            const Divider(height: 40, thickness: 1),
            
            Text(
              item.body,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleNavigation(context, item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Lakukan Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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

    } else if (titleLower.contains('laporan') || titleLower.contains('history')) {
      Navigator.pushNamed(context, '/history');

    } else if (titleLower.contains('makan') || titleLower.contains('sarapan') || titleLower.contains('scan')) {
      Navigator.pushNamed(context, '/scan');

    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }
}