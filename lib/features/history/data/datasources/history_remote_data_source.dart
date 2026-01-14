import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../scan/data/models/scan_result_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<ScanResultModel>> getHistory(String email);
  Future<void> deleteHistory(List<int> ids);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final http.Client client;
  HistoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ScanResultModel>> getHistory(String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/scan/history?email=$email');
    final headers = await _getHeaders();

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List data = jsonResponse['data'];
      return data.map((e) {
        return ScanResultModel.fromJson(e, e['image_path'] ?? "");
      }).toList();
    } else {
      throw Exception('Server Error: ${response.body}');
    }
  }

  @override
  Future<void> deleteHistory(List<int> ids) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/scan/history');
    final headers = await _getHeaders();

    try {
      final response = await client.delete(
        uri,
        headers: headers,
        body: json.encode({"ids": ids}),
      );

      print("DEBUG DELETE MULTIPLE: Status ${response.statusCode}");
      print("DEBUG BODY: ${response.body}");

      if (response.statusCode == 200) {
        return;
      } else {
        final errorMsg =
            json.decode(response.body)['message'] ?? 'Gagal hapus data massal';
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception('Koneksi Gagal: $e');
    }
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
