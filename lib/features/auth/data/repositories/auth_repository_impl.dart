import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> registerFirebase(String email, String password) async {
    return await remoteDataSource.registerFirebase(email, password);
  }

  @override
  Future<User> loginFirebase(String email, String password) async {
    return await remoteDataSource.loginFirebase(email, password);
  }

  @override
  Future<void> syncToBackend(String uid, String fullName, String email) async {
    return await remoteDataSource.syncToBackend(uid, fullName, email);
  }

  @override
  Future<bool> checkUserStatus(String email) async {
    return await remoteDataSource.checkUserStatus(email);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    return await remoteDataSource.sendPasswordResetEmail(email);
  }
}