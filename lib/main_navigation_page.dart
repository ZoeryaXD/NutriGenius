import 'package:flutter/material.dart';
import 'package:nutrigenius/features/profile/presentation/pages/profile_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'dummy_page.dart' hide NotificationPage; 

// === TAMBAHAN PENTING (SOLUSI ERROR MERAH) ===
// Pastikan path ini sesuai dengan tempat Mas menyimpan file notifikasi tadi
import 'features/notification/presentation/pages/notification_page.dart'; 

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    DashboardPage(),
    LogPage(), 
    NotificationPage(), // Sekarang ini tidak akan merah lagi
    ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai urutan index
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, 
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.green[800], 
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.spa),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book), 
              label: 'Log',
            ),
            // Menu Notifikasi
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined), // Pakai outlined biar lebih estetik saat tidak aktif
              activeIcon: Icon(Icons.notifications),    // Icon full saat aktif
              label: 'Notif',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}