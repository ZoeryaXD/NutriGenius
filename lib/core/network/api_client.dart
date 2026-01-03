import 'dart:io';

class ApiClient {
  // Pastikan angka ini 168 (umumnya Wi-Fi lokal), bukan 169
  static const String _laptopIp = '192.168.70.165';

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://$_laptopIp:3000/api';
    } else {
      // Untuk Emulator atau Desktop
      return 'http://10.0.2.2:3000/api';
    }
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
