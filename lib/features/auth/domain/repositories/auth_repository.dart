import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User> registerFirebase(String email, String password);
  Future<User> loginFirebase(String email, String password);
  Future<void> syncToBackend(String uid, String fullName, String email);
  Future<bool> checkUserStatus(String email);
  Future<void> sendPasswordResetEmail(String email);
}