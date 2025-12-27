import 'package:flutter/material.dart';
// Import halaman-halaman yang mau ditampilkan
import 'dashboard_page.dart';
import 'dummy_page.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0; // Menyimpan status tab mana yang aktif (0 = Home)

  // Daftar Halaman yang akan ditampilkan sesuai urutan tab
  final List<Widget> _pages = [
    DashboardPage(),      // Index 0: Home
    LogPage(),            // Index 1: Log
    NotificationPage(),   // Index 2: Notif
    ProfilePage(),        // Index 3: Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Ubah index saat tombol diklik
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan halaman sesuai index yang dipilih
      body: _pages[_selectedIndex], 

      // Navigasi Bawah
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Wajib fixed kalau item > 3
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.green[800], // Warna Ikon Aktif (Hijau Tua)
          unselectedItemColor: Colors.grey,     // Warna Ikon Mati
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.spa), // Ikon Daun
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book), // Ikon Buku/Log
              label: 'Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications), // Ikon Lonceng
              label: 'Notif',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), // Ikon Orang
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}