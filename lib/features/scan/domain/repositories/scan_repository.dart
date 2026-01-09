import 'package:dartz/dartz.dart';
import 'package:nutrigenius/core/error/failures.dart';
import '../entities/scan_result.dart';

abstract class ScanRepository {
  Future<Either<Failure, ScanResult>> analyzeImage(String imagePath, String email);
  Future<Either<Failure, void>> saveScan(ScanResult result, String email);
}