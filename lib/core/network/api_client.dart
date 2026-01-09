import 'package:flutter/foundation.dart';

class ApiClient {
  static const String _laptopIp = '192.169.0.3';
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    return 'http://$_laptopIp:3000/api';
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
