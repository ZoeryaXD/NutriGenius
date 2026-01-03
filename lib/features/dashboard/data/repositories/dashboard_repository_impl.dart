import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/network/api_client.dart';

import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final http.Client client;

  DashboardRepositoryImpl({required this.client});

  @override
  Future<DashboardEntity> loadDashboardData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception("User belum login");
      }
      
      final url = Uri.parse('${ApiClient.baseUrl}/dashboard');
      
      final response = await client.post(
        url,
        headers: ApiClient.headers,
        body: jsonEncode({'email': user.email}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];

          return DashboardModel.fromJson(data);
          
        } else {

          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {

      throw Exception('Gagal memuat dashboard: $e');
    }
  }
}