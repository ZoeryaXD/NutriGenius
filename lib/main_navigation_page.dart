import 'package:flutter/material.dart';
import 'package:nutrigenius/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nutrigenius/features/history/presentation/pages/history_page.dart';
import 'package:nutrigenius/features/profile/presentation/pages/profile_page.dart';
import 'package:nutrigenius/dummy_page.dart';

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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
                  backgroundColor: theme.colorScheme.surface,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Icon(
                      Icons.spa_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: IconThemeData(
                    color: primaryColor,
                    size: 28,
                  ),
                  selectedLabelTextStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: theme.hintColor,
                    size: 24,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: theme.hintColor,
                    fontSize: 11,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long_rounded),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.notifications_none_rounded),
                      selectedIcon: Icon(Icons.notifications_rounded),
                      label: Text('Notif'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: theme.dividerColor,
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
                    backgroundColor: theme.colorScheme.surface,
                    selectedItemColor: primaryColor,
                    unselectedItemColor: theme.hintColor,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard_outlined),
                        activeIcon: Icon(Icons.dashboard_rounded),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_long_outlined),
                        activeIcon: Icon(Icons.receipt_long_rounded),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_none_rounded),
                        activeIcon: Icon(Icons.notifications_rounded),
                        label: 'Notif',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline_rounded),
                        activeIcon: Icon(Icons.person_rounded),
                        label: 'Profile',
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
