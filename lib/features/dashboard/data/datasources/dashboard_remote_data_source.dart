import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData(String email);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getDashboardData(String email) async {
    final url = Uri.parse('${ApiClient.baseUrl}/dashboard');
    try {
      final response = await client.post(
        url,
        headers: ApiClient.headers,
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        return responseBody['data'];
      } else {
        throw Exception(
          'Gagal mengambil data dashboard: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error Koneksi Dashboard: $e');
    }
  }
}
