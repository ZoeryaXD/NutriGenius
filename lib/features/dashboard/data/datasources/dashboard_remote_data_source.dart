import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData(String email);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;
  // Sesuaikan IP: 10.0.2.2 untuk Emulator, IP LAN untuk HP Fisik
  static const String baseUrl = 'http://192.169.0.5:3000/api/dashboard';

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getDashboardData(String email) async {
    // Panggil Endpoint: GET /get-data?email=...
    final response = await client.get(
      Uri.parse('$baseUrl/get-data?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // Mengembalikan objek 'data' dari JSON response
      return responseBody['data'];
    } else {
      throw Exception('Gagal mengambil data dashboard dari server');
    }
  }
}