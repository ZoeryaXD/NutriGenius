import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna teks judul
    final Color primaryGreen = const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan SafeArea agar tidak tertutup status bar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Text(
                "Notifikasi",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 24),

              // --- Bagian: Hari Ini ---
              const Text(
                "Hari ini",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),

              _buildNotificationCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                iconBgColor: Colors.red.withOpacity(0.1),
                title: "Peringatan Gula Tinggi!",
                body: "Makanan yang kamu scan mengandung gula berlebih (25g).",
                borderColor: Colors.red,
                showDot: true,
                dotColor: Colors.red,
              ),

              _buildNotificationCard(
                icon: Icons.lunch_dining,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.withOpacity(0.1),
                title: "Waktunya Makan Siang",
                body: "Sudah jam 12:30, jangan lupa catat asupanmu.",
                borderColor: Colors.orange,
                showDot: true,
                dotColor: Colors.orange,
              ),

              _buildNotificationCard(
                icon: Icons.water_drop,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withOpacity(0.1),
                title: "Tips Hidrasi",
                body: "Cuaca panas, jangan lupa minum 2 liter air.",
                borderColor: Colors.blue,
                showDot: true,
                dotColor: Colors.blue,
              ),

              const SizedBox(height: 24),

              // --- Bagian: Kemarin ---
              const Text(
                "Kemarin",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),

              _buildNotificationCard(
                icon: Icons.emoji_events,
                iconColor: Colors.green,
                iconBgColor: Colors.green.withOpacity(0.1),
                title: "Target Protein Tercapai 🎉",
                body: "Kerja bagus! Asupan proteinmu sudah optimal.",
                isOld: true, // Style khusus untuk notifikasi lama
              ),

              _buildNotificationCard(
                icon: Icons.bar_chart,
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withOpacity(0.1),
                title: "Laporan Mingguan",
                body: "Lihat grafik kemajuan berat badanmu minggu ini.",
                isOld: true,
              ),

              _buildNotificationCard(
                icon: Icons.menu_book,
                iconColor: Colors.teal,
                iconBgColor: Colors.teal.withOpacity(0.1),
                title: "Resep Baru",
                body: "Coba resep 'Salad Quinoa' untuk makan malam.",
                isOld: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Reusable untuk Item Notifikasi ---
  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String body,
    Color? borderColor, // Opsional: Hanya untuk 'Hari ini'
    bool showDot = false, // Opsional: Indikator merah/biru di kanan
    Color? dotColor,
    bool isOld = false, // Jika true, background abu & tanpa border
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOld ? Colors.grey[100] : Colors.white, // Beda background
        borderRadius: BorderRadius.circular(20),
        border: isOld
            ? null // Tidak ada border untuk 'Kemarin'
            : Border.all(color: borderColor ?? Colors.transparent, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Bulat
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),

          // Teks Judul & Isi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green[900], // Warna hijau gelap mendekati hitam
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4, // Spasi antar baris agar nyaman dibaca
                  ),
                ),
              ],
            ),
          ),

          // Dot Indikator (Jika ada)
          if (showDot && dotColor != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: dotColor,
              ),
            ),
        ],
      ),
    );
  }
}