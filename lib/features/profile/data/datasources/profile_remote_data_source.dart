import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String email);
  Future<void> updateProfile(Map<String, dynamic> data);
  Future<String> uploadPhoto(String email, File file);
  Future<void> deletePhoto(String email);
  Future<void> deleteAccount(String email);

  Future<List<ActivityLevelModel>> getActivityLevels();
  Future<List<HealthConditionModel>> getHealthConditions();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ProfileModel> getProfile(String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/profile?email=$email');
    final response = await client.get(uri, headers: ApiClient.headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProfileModel.fromJson(json['data']);
    } else {
      throw Exception("Gagal memuat profil");
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/profile/update');
    final response = await client.put(
      uri,
      headers: ApiClient.headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update profil");
    }
  }

  @override
  Future<String> uploadPhoto(String email, File file) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/profile/upload-photo');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['filename']; // Balikan nama file baru
    } else {
      throw Exception("Gagal upload foto");
    }
  }

  @override
  Future<void> deletePhoto(String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/profile/delete-photo');

    final request = http.Request('DELETE', uri);
    request.headers.addAll(ApiClient.headers);
    request.body = jsonEncode({'email': email});

    final streamedResponse = await client.send(request);
    if (streamedResponse.statusCode != 200) throw Exception("Gagal hapus foto");
  }

  @override
  Future<void> deleteAccount(String email) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/profile/delete-account');
    final request = http.Request('DELETE', uri);
    request.headers.addAll(ApiClient.headers);
    request.body = jsonEncode({'email': email});

    final streamedResponse = await client.send(request);
    if (streamedResponse.statusCode != 200) throw Exception("Gagal hapus akun");
  }

  @override
  Future<List<ActivityLevelModel>> getActivityLevels() async {
    final url = Uri.parse('${ApiClient.baseUrl}/firstpage/activities');
    final response = await client.get(url, headers: ApiClient.headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => ActivityLevelModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal load activity levels');
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
      throw Exception('Gagal load health conditions');
    }
  }
}
