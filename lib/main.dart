import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/dashboard/presentation/pages/main_navigation_page.dart';
import 'firebase_options.dart'; // File otomatis dari flutterfire configure
import 'injection_container.dart' as di; // Dependency Injection

// Import Pages
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Import FirstPage Main Container
import 'features/firstpage/presentation/pages/firstpage_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 2. Init Dependency Injection
  await di.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()), // Inject AuthBloc
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NutriGenius',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Poppins', // Pastikan font sudah didaftarkan di pubspec.yaml
        ),
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