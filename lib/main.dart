import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/dashboard/pages/dashboard_page.dart';
import 'package:nutrigenius/features/main_page.dart';
import 'package:nutrigenius/features/profile/pages/profile_page.dart';
import 'core/usecases/db_helper.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/history/presentation/bloc/history_event.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/notification/pages/notification_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryBloc>(
          create: (context) =>
              HistoryBloc(DatabaseHelper.instance)..add(LoadHistory()),
        ),
      ],
      child: MaterialApp(
        title: 'NutriGenius',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            primary: const Color(0xFF2E7D32),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),

        initialRoute: '/mainpage',

        routes: {
          '/dashboard': (context) => const DashboardPage(),
          '/history': (context) => const HistoryPage(),
          '/notification': (context) => const NotificationPage(),
          '/profile': (context) => const ProfilePage(),
          '/mainpage': (context) => const MainPage(),
        },
      ),
    );
  }
}
