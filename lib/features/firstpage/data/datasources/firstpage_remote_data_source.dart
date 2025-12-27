import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class FirstpageRemoteDataSource {
  Future<void> submitProfile(Map<String, dynamic> data);
}

class FirstpageRemoteDataSourceImpl implements FirstpageRemoteDataSource {
  final http.Client client;
  // Ganti 10.0.2.2 dengan IP Laptop jika pakai HP Fisik
  static const String baseUrl = 'http://192.169.0.5:3000/api/firstpage';

  FirstpageRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitProfile(Map<String, dynamic> data) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/complete-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menyimpan profil: ${response.body}');
      }
    } catch (e) {
      throw Exception('Server Error: $e');
    }
  }
}