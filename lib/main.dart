import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/main_navigation_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

// Auth Imports
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// First Page Import
import 'features/firstpage/presentation/pages/firstpage_main.dart';

// Scan Imports (TAMBAHKAN INI)
import 'features/scan/presentation/bloc/scan_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi Service Locator (Dependency Injection)
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Mendaftarkan AuthBloc agar bisa diakses di semua halaman
        BlocProvider(create: (_) => di.sl<AuthBloc>()),

        // Mendaftarkan ScanBloc (TAMBAHKAN INI)
        BlocProvider(create: (_) => di.sl<ScanBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NutriGenius',
        theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Poppins'),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/firstpage': (context) => FirstPageMain(),
          '/dashboard': (context) => MainNavigationPage(),
        },
      ),
    );
  }
}
