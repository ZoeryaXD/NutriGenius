import 'dart:io';

class ApiClient {
  static const String _laptopIp = '192.169.0.6';
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://$_laptopIp:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
