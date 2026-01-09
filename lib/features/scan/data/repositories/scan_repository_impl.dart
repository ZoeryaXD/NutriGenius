import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';
import '../datasources/scan_remote_data_source.dart';
import '../models/scan_result_model.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanRemoteDataSource remoteDataSource;
  
  ScanRepositoryImpl({
    required this.remoteDataSource,
  });

  // ==========================================
  // 1. ANALYZE IMAGE (Preview)
  // ==========================================
  @override
  Future<Either<Failure, ScanResult>> analyzeImage(
    String imagePath,
    String email,
  ) async {
    try {
      final remoteScan = await remoteDataSource.analyzeImage(imagePath, email);
      return Right(remoteScan);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================
  // 2. GET HISTORY (Ambil Data) - 👇 TAMBAHAN
  // ==========================================
  Future<Either<Failure, List<ScanResult>>> getHistory(String email) async {
    try {
      final remoteHistory = await remoteDataSource.getHistory(email);
      return Right(remoteHistory);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================
  // 3. SAVE SCAN (Simpan ke DB) - 👇 TAMBAHAN
  // ==========================================
  Future<Either<Failure, void>> saveScan(ScanResult result, String email) async {
    try {
      final model = ScanResultModel(
        id: 0,
        foodName: result.foodName,
        calories: result.calories,
        protein: result.protein,
        carbs: result.carbs,
        fat: result.fat,
        sugar: result.sugar,
        aiSuggestion: result.aiSuggestion,
        imagePath: result.imagePath,
        date: DateTime.now(),
      );

      await remoteDataSource.saveScan(model, email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}