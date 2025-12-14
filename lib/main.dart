import 'package:flutter/material.dart';
import 'package:nutrigenius/features/auth/presentation/routes/auth_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriGenius',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        ...AuthRoutes.routes,
      },
    );
  }
}