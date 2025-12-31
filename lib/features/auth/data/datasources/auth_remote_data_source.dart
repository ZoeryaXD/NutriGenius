import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<User> registerFirebase(String email, String password);
  Future<User> loginFirebase(String email, String password);
  Future<void> syncToBackend(String uid, String fullName, String email);
  Future<bool> checkUserStatus(String email);
  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.client});

  @override
  Future<User> registerFirebase(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } catch (e) {
      throw Exception('Firebase Register Error: $e');
    }
  }

  @override
  Future<User> loginFirebase(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found')
          throw Exception('Email tidak terdaftar.');
        if (e.code == 'wrong-password') throw Exception('Password salah.');
      }
      throw Exception('Gagal Login: ${e.toString()}');
    }
  }

  @override
  Future<void> syncToBackend(String uid, String fullName, String email) async {
    final url = Uri.parse('${ApiClient.baseUrl}/auth/sync-register');

    try {
      final response = await client.post(
        url,
        headers: ApiClient.headers,
        body: jsonEncode({
          'firebaseUid': uid,
          'fullName': fullName,
          'email': email,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal sinkronisasi ke server: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat sinkronisasi: $e');
    }
  }

  @override
  Future<bool> checkUserStatus(String email) async {
    final url = Uri.parse('${ApiClient.baseUrl}/auth/check-status');
    try {
      final response = await client.post(
        url,
        headers: ApiClient.headers,
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isOnboarded'] ?? false;
      } else if (response.statusCode == 404) {
        throw Exception('User data not found in database');
      } else {
        throw Exception('Gagal cek status user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Koneksi Status: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
