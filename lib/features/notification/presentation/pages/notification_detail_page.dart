import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/notification_entity.dart';

// Import halaman tujuan aksi
import '../../../profile/presentation/pages/profile_page.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationEntity item;

  const NotificationDetailPage({super.key, required this.item});

  bool get _shouldShowButton {
    if (item.category == 'motivation') return false;

    if (item.category == 'system') {
      final titleLower = item.title.toLowerCase();
      if (titleLower.contains('tips')) return false; 
      return true; 
    }

    return true; 
  }

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
              tag: item.id, 
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 50),
              ),
            ),
            const SizedBox(height: 24),

            Chip(
              label: Text(
                _getCategoryLabel(item.category),
                style: TextStyle(color: item.color, fontWeight: FontWeight.bold),
              ),
              backgroundColor: item.color.withOpacity(0.05),
              side: BorderSide.none,
            ),
            const SizedBox(height: 24),

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

            if (_shouldShowButton)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleNavigation(context),
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

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'reminder': return 'PENGINGAT';
      case 'motivation': return 'MOTIVASI';
      case 'system': return 'INFO SISTEM';
      default: return 'INFO';
    }
  }

  void _handleNavigation(BuildContext context) {
    final String titleLower = item.title.toLowerCase();

    if (titleLower.contains('profil') || titleLower.contains('lengkap')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()), 
      );
    } 
    else if (titleLower.contains('makan') || titleLower.contains('sarapan')) {
      Navigator.pushNamed(context, '/scan');
    }
    else if (titleLower.contains('laporan')) {
      Navigator.pushNamed(context, '/history');
    }
    else {
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }
}