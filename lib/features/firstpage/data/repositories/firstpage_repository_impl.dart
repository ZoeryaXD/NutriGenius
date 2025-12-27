import '../../domain/repositories/firstpage_repository.dart';
import '../datasources/firstpage_remote_data_source.dart';
import '../datasources/firstpage_local_remote_data_source.dart';
import '../models/firstpage_model.dart';

class FirstPageRepositoryImpl implements FirstPageRepository {
  final FirstpageRemoteDataSource remoteDataSource;
  final FirstPageLocalDataSource localDataSource;
  
  FirstPageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource});

  @override
  Future<void> submitProfile({
    required String email,
    required String gender,
    required DateTime birthDate,
    required double weight,
    required double height,
    required int activityId,
    required int healthId,
    required double bmr,
    required double tdee,
  }) async {
    // 1. Format Tanggal ke YYYY-MM-DD
    String formattedDate = "${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";

    // 2. Buat Model Data
    final model = FirstPageModel(
      email: email,
      gender: gender,
      birthDate: formattedDate,
      weight: weight,
      height: height,
      activityId: activityId,
      healthId: healthId,
      bmr: bmr,
      tdee: tdee,
    );

    // 3. Kirim ke Backend
    await remoteDataSource.submitProfile(model.toJson());

    await localDataSource.cacheProfile(model);
  }
}