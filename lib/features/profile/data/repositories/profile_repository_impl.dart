import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProfileEntity> getProfile() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    try {
      final remoteProfile = await remoteDataSource.getProfile(email);

      await localDataSource.saveProfile(remoteProfile);

      return remoteProfile;
    } catch (e) {
      print("Gagal ambil remote, menggunakan data lokal: $e");
      return await localDataSource.getProfile();
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final model = ProfileModel(
      name: profile.name,
      email: profile.email,
      gender: profile.gender,
      weight: profile.weight,
      height: profile.height,
      birthDate: profile.birthDate,
    );

    await remoteDataSource.updateProfile(model);
    await localDataSource.saveProfile(model);
  }
}
