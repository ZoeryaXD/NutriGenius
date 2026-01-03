import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/firebase_options.dart';
import 'package:nutrigenius/injection_container.dart' as di;

// Import Pages
import 'package:nutrigenius/features/auth/presentation/pages/login_page.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nutrigenius/features/history/presentation/bloc/history_bloc.dart';
import 'package:nutrigenius/features/history/presentation/bloc/history_event.dart';

import 'features/auth/presentation/pages/register_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/firstpage/presentation/pages/firstpage_main.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/main/pages/main_page.dart';
import 'features/notification/presentation/pages/notification_page.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_event.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init(); // Wajib diinisialisasi

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
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<HistoryBloc>()..add(LoadHistory())),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()..add(LoadProfile())),
      ],
      child: MaterialApp(
        title: 'NutriGenius',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF2E7D32),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/',

        routes: {
          // Routes dari Auth & FirstPage
          '/': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/firstpage': (context) => FirstPageMain(),

          // Routes Fitur Utama
          '/mainpage': (context) => MainPage(),
          '/dashboard': (context) => DashboardPage(),
          '/history': (context) => HistoryPage(),
          '/notification': (context) => NotificationPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
