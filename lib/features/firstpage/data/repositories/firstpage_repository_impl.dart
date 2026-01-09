import '../../domain/repositories/firstpage_repository.dart';
import '../datasources/firstpage_remote_data_source.dart';
import '../models/firstpage_model.dart';

class FirstPageRepositoryImpl implements FirstPageRepository {
  final FirstpageRemoteDataSource remoteDataSource;

  FirstPageRepositoryImpl({required this.remoteDataSource});
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
    String formattedDate =
        "${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";

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

    await remoteDataSource.submitProfile(model.toJson());
  }
}
