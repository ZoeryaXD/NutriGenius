import 'package:flutter/material.dart';

// Halaman Log (Jurnal Makanan)
class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Fitur Log Makanan (Segera Hadir)",
          style: TextStyle(color: Colors.green, fontSize: 18),
        ),
      ),
    );
  }
}

// Halaman Notifikasi
class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Belum ada notifikasi",
          style: TextStyle(color: Colors.green, fontSize: 18),
        ),
      ),
    );
  }
}

// Halaman Profil
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Halaman Profil User",
          style: TextStyle(color: Colors.green, fontSize: 18),
        ),
      ),
    );
  }
}
