import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'injection.dart' as di;

// Import Halaman-halaman yang dibutuhkan
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/dashboard/presentation/pages/main_navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Inisialisasi Dependency Injection

  // Mengatur Status Bar transparan
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
    return MaterialApp(
      title: 'NutriGenius',
      debugShowCheckedModeBanner: false,

      // Mengatur Tema Global
      theme: ThemeData(
        // Sesuaikan primaryColor dengan AppColors kamu
        primaryColor: const Color(0xFF2E7D32), // Atau AppColors.primaryGreen
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      // 1. Tentukan Halaman Awal adalah Login
      home: const LoginPage(),

      // 2. Daftarkan Rute (Named Routes)
      // Ini wajib ada karena di LoginPage temanmu memanggil:
      // Navigator.pushReplacementNamed(context, '/dashboard');
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const MainNavigationPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
