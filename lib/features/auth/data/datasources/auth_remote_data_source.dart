import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<User> registerFirebase(String email, String password);
  Future<User> loginFirebase(String email, String password);
  Future<void> syncToBackend(String uid, String fullName, String email);
  Future<bool> checkUserStatus(String email); // Return true jika sudah onboarding
  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final http.Client client;

  // Ganti IP ini sesuai device:
  // Emulator Android: 10.0.2.2
  // Real Device/iOS: IP Laptop (misal 192.168.1.x)
  static const String baseUrl = 'http://192.169.0.5:3000/api/auth';

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.client});

  @override
  Future<User> registerFirebase(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
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
        password: password
      );
      return credential.user!;
    } catch (e) {
      throw Exception('Email atau password salah.');
    }
  }

  @override
  Future<void> syncToBackend(String uid, String fullName, String email) async {
    final response = await client.post(
      Uri.parse('$baseUrl/sync-register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firebaseUid': uid,
        'fullName': fullName,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal sinkronisasi ke server: ${response.body}');
    }
  }

  @override
  Future<bool> checkUserStatus(String email) async {
    final response = await client.post(
      Uri.parse('$baseUrl/check-status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isOnboarded'];
    } else {
      throw Exception('Gagal cek status user');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}