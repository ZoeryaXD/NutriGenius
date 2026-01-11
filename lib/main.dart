import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:nutrigenius/features/scan/presentation/pages/scan_page.dart';
import 'package:nutrigenius/main_navigation_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/scan/presentation/bloc/scan_bloc.dart';

import 'features/history/presentation/bloc/history_bloc.dart'; 
import 'features/firstpage/presentation/pages/firstpage_main.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<DashboardBloc>()),
        BlocProvider(create: (_) => di.sl<ScanBloc>()),
        BlocProvider(create: (_) => di.sl<HistoryBloc>()), 
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
          '/scan': (context) => ScanPage(),
          '/history': (context) => HistoryPage(),
        },
      ),
    );
  }
}