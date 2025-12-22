import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'home_page.dart';
import 'placeholder_pages.dart'; // Import placeholder yang baru dibuat

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0; // Index 0 = Home

  // Daftar halaman yang akan ditampilkan sesuai urutan ikon di bawah
  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berganti sesuai index yang dipilih
      body: _pages[_currentIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type:
              BottomNavigationBarType
                  .fixed, // Agar label tetap muncul (opsional)
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen, // Hijau saat aktif
          unselectedItemColor: Colors.grey, // Abu-abu saat tidak aktif
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.eco), // Ikon Daun/Home
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), // Ikon History Log
              label: 'History Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), // Ikon Lonceng
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), // Ikon Orang
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
