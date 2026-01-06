import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../models/scan_result_model.dart';
import 'package:http_parser/http_parser.dart';

abstract class ScanRemoteDataSource {
  Future<ScanResultModel> analyzeImage(String imagePath, String email);
  Future<List<ScanResultModel>> getHistory(String email);
  Future<void> saveScan(ScanResultModel data, String email);
}

class ScanRemoteDataSourceImpl implements ScanRemoteDataSource {
  final http.Client client;

  ScanRemoteDataSourceImpl({required this.client});

  // ==========================================
  // 1. ANALYZE IMAGE (Preview dari Gemini)
  // ==========================================
  @override
  Future<ScanResultModel> analyzeImage(String imagePath, String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/scan/analyze');

    var request = http.MultipartRequest('POST', uri);
    request.fields['email'] = email;

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(multipartFile);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    try {
      print("🚀 Mengirim gambar ke: $uri");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Log Response Analyze: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'];
        return ScanResultModel.fromJson(data);
      } else {
        throw Exception('Gagal Scan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Eror Koneksi Analyze: $e');
    }
  }

  // ==========================================
  // 2. GET HISTORY (Ambil Data Riwayat)
  // ==========================================
  @override
  Future<List<ScanResultModel>> getHistory(String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/scan/history?email=$email');

    try {
      // Ambil Token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await client.get(uri, headers: headers);

      print("Log Response History: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List data = jsonResponse['data'];

        // Mapping List JSON ke List Model
        return data.map((e) => ScanResultModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal ambil history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Eror Koneksi History: $e');
    }
  }

  // ==========================================
  // 3. SAVE SCAN (Simpan ke Database)
  // ==========================================
  @override
  Future<void> saveScan(ScanResultModel data, String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/scan/save');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      // Kirim Data JSON sesuai field yang diminta Backend
      final body = json.encode({
        "email": email,
        "food_name": data.foodName,
        "calories": data.calories.toString(),
        "protein": data.protein.toString(),
        "carbs": data.carbs.toString(),
        "fat": data.fat.toString(),
        "sugar": data.sugar.toString(),
        "ai_suggestion": data.aiSuggestion,
        "image_path": data.imagePath, // Nama file hasil upload di tahap analyze
      });

      print("💾 Mengirim Request Simpan: $body");

      final response = await client.post(uri, headers: headers, body: body);

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception("Gagal menyimpan: ${response.body}");
      }
    } catch (e) {
      throw Exception("Eror Koneksi Save: $e");
    }
  }
}
