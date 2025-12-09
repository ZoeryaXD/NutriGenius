import 'package:flutter/material.dart';
import 'package:nutrigenius/features/auth/presentation/pages/login_page.dart';

class AuthRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      '/login': (context) => const LoginPage(),
      // '/register': (context) => const RegisterPage(), // Comment atau hapus sementara
    };
  }
}