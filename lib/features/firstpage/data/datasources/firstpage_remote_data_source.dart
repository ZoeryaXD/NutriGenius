import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';
import '../models/firstpage_model.dart';

abstract class FirstpageRemoteDataSource {
  Future<void> submitProfile(Map<String, dynamic> data);
  Future<List<ActivityLevelModel>> getActivities();
  Future<List<HealthConditionModel>> getHealthConditions();
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

  @override
  Future<List<ActivityLevelModel>> getActivities() async {
    final url = Uri.parse('${ApiClient.baseUrl}/firstpage/activities');

    final response = await client.get(url, headers: ApiClient.headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((json) => ActivityLevelModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data activity: ${response.body}');
    }
  }

  @override
  Future<List<HealthConditionModel>> getHealthConditions() async {
    final url = Uri.parse('${ApiClient.baseUrl}/firstpage/health-conditions');

    final response = await client.get(url, headers: ApiClient.headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((json) => HealthConditionModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Gagal mengambil data health conditions: ${response.body}',
      );
    }
  }
}
