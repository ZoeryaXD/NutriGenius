import 'package:flutter/material.dart';
import 'package:nutrigenius/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nutrigenius/features/history/presentation/pages/history_page.dart';
import 'package:nutrigenius/features/profile/presentation/pages/profile_page.dart';
import 'package:nutrigenius/dummy_page.dart'; // Pastikan NotificationPage ada di sini

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    HistoryPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;

        return Scaffold(
          body: Row(
            children: [
              if (isWideScreen) ...[
                NavigationRail(
                  extended: false,
                  selectedIndex: _currentIndex,
                  onDestinationSelected:
                      (index) => setState(() => _currentIndex = index),
                  backgroundColor: Colors.white,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Icon(Icons.spa, color: Color(0xFF2E7D32), size: 30),
                  ),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(
                    color: Color(0xFF2E7D32),
                    size: 28,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: Colors.grey,
                    size: 24,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.notifications_none),
                      selectedIcon: Icon(Icons.notifications),
                      label: Text('Notif'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Color(0xFFEEEEEE),
                ),
              ],
              Expanded(child: _pages[_currentIndex]),
            ],
          ),
          bottomNavigationBar:
              isWideScreen
                  ? null
                  : BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    selectedItemColor: const Color(0xFF2E7D32),
                    unselectedItemColor: Colors.grey,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard_outlined),
                        activeIcon: Icon(Icons.dashboard),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_long_outlined),
                        activeIcon: Icon(Icons.receipt_long),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_none),
                        activeIcon: Icon(Icons.notifications),
                        label: 'Notif',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        activeIcon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
