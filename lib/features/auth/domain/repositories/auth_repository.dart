import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrigenius/features/auth/data/models/user_model.dart';
import 'package:nutrigenius/features/auth/data/datasources/auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<UserCredential> login(String email, String password);
  Future<UserCredential> register(String email, String password);
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<void> reloadUser();
  User? getCurrentUser();
  Stream<User?> authStateChanges();
  
  // Tambah method baru untuk check profile completion
  Future<bool> hasUserCompletedProfile();
  Future<void> saveUserProfile(UserModel user);
  Future<UserModel?> getUserProfile();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserCredential> login(String email, String password) async {
    return await remoteDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> register(String email, String password) async {
    return await remoteDataSource.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    await remoteDataSource.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    await remoteDataSource.reloadUser();
    return remoteDataSource.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> reloadUser() async {
    await remoteDataSource.reloadUser();
  }

  @override
  User? getCurrentUser() {
    return remoteDataSource.currentUser;
  }

  @override
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  // Implementasi baru
  @override
  Future<bool> hasUserCompletedProfile() async {
    // Cek di local storage atau Firestore
    // Untuk sementara, kita return false untuk user baru
    final user = getCurrentUser();
    if (user == null) return false;
    
    // TODO: Implement Firestore check
    return false; // Default false untuk user baru
  }

  @override
  Future<void> saveUserProfile(UserModel user) async {
    // TODO: Implement save to Firestore
    // Set hasCompletedProfile = true setelah mengisi data
  }

  @override
  Future<UserModel?> getUserProfile() async {
    // TODO: Implement get from Firestore
    return null;
  }
}