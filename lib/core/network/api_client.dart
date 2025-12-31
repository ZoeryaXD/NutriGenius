import 'dart:io'; 

class ApiClient {
  // ==================================================================
  // Cara cek: Buka CMD -> ketik ipconfig -> Cari IPv4 di "Wireless LAN"
  // Pastikan BUKAN alamat Gateway (.1), tapi alamat IPv4 (.5, .10, dll)
  // ==================================================================
  static const String _laptopIp = '192.169.0.4';
  // Logika Otomatis:
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Jika dijalankan di HP Fisik, gunakan IP Laptop
      return 'http://$_laptopIp:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}