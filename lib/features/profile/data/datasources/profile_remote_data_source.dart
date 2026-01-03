import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutrigenius/core/network/api_client.dart';

import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String email);
  Future<void> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ProfileModel> getProfile(String email) async {
    final url = Uri.parse(
      '${ApiClient.baseUrl}/dashboard/get-data?email=$email',
    );
    final response = await client.get(url, headers: ApiClient.headers);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return ProfileModel.fromJson(responseBody['data']);
    } else {
      throw Exception('Gagal ambil data profil dari server');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    final url = Uri.parse('${ApiClient.baseUrl}/profile/update');

    final response = await client.post(
      url,
      headers: ApiClient.headers,
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memperbarui profil di server. Status: ${response.statusCode}',
      );
    }
  }
}
