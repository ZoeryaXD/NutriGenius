import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nutrigenius/features/scan/presentation/pages/scan_page.dart';
import 'package:nutrigenius/main_navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/scan/presentation/bloc/scan_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/firstpage/presentation/pages/firstpage_main.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await initializeDateFormatting('id_ID', null);

  final pref = await SharedPreferences.getInstance();
  bool isDark = pref.getBool('darkMode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<HistoryBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
        BlocProvider(create: (_) => di.sl<ScanBloc>()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, mode, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NutriGenius',
            themeMode: mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(),
              '/register': (context) => RegisterPage(),
              '/firstpage': (context) => FirstPageMain(),
              '/dashboard': (context) => MainNavigationPage(),
              '/history': (context) => HistoryPage(),
              '/scan': (context) => ScanPage(),
            },
          );
        },
      ),
    );
  }
}
