import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../models/history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryModel>> getHistory(String email);
  Future<void> deleteHistory(int id);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final http.Client client;

  HistoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<HistoryModel>> getHistory(String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/history?email=$email');
    final headers = await _getHeaders();

    try {
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List data = jsonResponse['data'] ?? [];
        return data.map((e) => HistoryModel.fromMap(e)).toList();
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal koneksi: $e');
    }
  }

  @override
  Future<void> deleteHistory(int id) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/history?email=$id');
    final headers = await _getHeaders();
    final response = await client.delete(uri, headers: headers);
    if (response.statusCode != 200) throw Exception('Gagal delete data');
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
