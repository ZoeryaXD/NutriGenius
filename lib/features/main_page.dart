import 'package:flutter/material.dart';
import 'package:nutrigenius/features/dashboard/pages/dashboard_page.dart';
import 'package:nutrigenius/features/history/presentation/pages/history_page.dart';
import 'package:nutrigenius/features/notification/pages/notification_page.dart';
import 'package:nutrigenius/features/profile/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
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
              if (isWideScreen)
                NavigationRail(
                  extended: constraints.maxWidth > 900,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _currentIndex = index),
                  leading: Column(
                    children: [
                      const SizedBox(height: 30),
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFE8F5E9),
                        child: Icon(Icons.spa, color: Color(0xFF2E7D32)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                  labelType: constraints.maxWidth > 900
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  backgroundColor: Colors.white,
                  selectedIconTheme: const IconThemeData(
                    color: Color(0xFF2E7D32),
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedIconTheme: const IconThemeData(color: Colors.grey),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.spa_outlined),
                      selectedIcon: Icon(Icons.spa),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.notifications_none),
                      selectedIcon: Icon(Icons.notifications),
                      label: Text('Notifications'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
              Expanded(child: _pages[_currentIndex]),
            ],
          ),
          bottomNavigationBar: isWideScreen
              ? null
              : BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: const Color(0xFF2E7D32),
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.spa_outlined),
                      activeIcon: Icon(Icons.spa),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long_outlined),
                      activeIcon: Icon(Icons.receipt_long),
                      label: 'History Log',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_none),
                      activeIcon: Icon(Icons.notifications),
                      label: 'Notifications',
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
