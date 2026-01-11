import 'package:flutter/material.dart';
import 'package:nutrigenius/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nutrigenius/features/history/presentation/pages/history_page.dart';
import 'package:nutrigenius/features/profile/presentation/pages/profile_page.dart';
import 'package:nutrigenius/features/notification/presentation/pages/notification_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const HistoryPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Row(
            children: [
              if (isWideScreen) ...[
                NavigationRail(
                  extended: false,
                  minWidth: 80,
                  selectedIndex: _currentIndex,
                  onDestinationSelected:
                      (index) => setState(() => _currentIndex = index),
                  backgroundColor: colorScheme.surface,
                  indicatorColor: colorScheme.primary.withOpacity(0.1),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Icon(
                      Icons.spa_rounded,
                      color: colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  selectedIconTheme: IconThemeData(
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  selectedLabelTextStyle: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: isDark ? Colors.white38 : Colors.grey,
                    size: 24,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey,
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
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ],
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _pages[_currentIndex],
                ),
              ),
            ],
          ),
          bottomNavigationBar:
              isWideScreen
                  ? null
                  : Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: (index) => setState(() => _currentIndex = index),
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: colorScheme.surface,
                      selectedItemColor: colorScheme.primary,
                      unselectedItemColor:
                          isDark ? Colors.white38 : Colors.grey,
                      selectedFontSize: 12,
                      unselectedFontSize: 12,
                      showUnselectedLabels: true,
                      elevation: 0,
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
                  ),
        );
      },
    );
  }
}
