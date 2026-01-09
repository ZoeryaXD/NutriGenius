import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';

abstract class FirstpageRemoteDataSource {
  Future<void> submitProfile(Map<String, dynamic> data);
}

class FirstpageRemoteDataSourceImpl implements FirstpageRemoteDataSource {
  final http.Client client;

  FirstpageRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitProfile(Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiClient.baseUrl}/firstpage/complete-profile');
    try {
      final response = await client.post(
        url,
        headers: ApiClient.headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Gagal menyimpan profil: ${response.body}');
      }
    } catch (e) {
      throw Exception('Server Error (FirstPage): $e');
    }
  }
}
