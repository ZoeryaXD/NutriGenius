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
    final url = Uri.parse('${ApiClient.baseUrl}/dashboard/get-data?email=$email');
    
    try {
      final response = await client.get(
        url,
        headers: ApiClient.headers,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        return responseBody['data'];
      } else {
        throw Exception('Gagal mengambil data dashboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Koneksi Dashboard: $e');
    }
  }
}