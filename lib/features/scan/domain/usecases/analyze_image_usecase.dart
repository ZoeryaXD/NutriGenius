import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class AnalyzeImageUseCase implements UseCase<ScanResult, AnalyzeImageParams> {
  final ScanRepository repository;

  AnalyzeImageUseCase(this.repository);

  @override
  Future<Either<Failure, ScanResult>> call(AnalyzeImageParams params) async {
    return await repository.analyzeImage(params.imagePath, params.email);
  }
}

class AnalyzeImageParams extends Equatable {
  final String imagePath;
  final String email;

  const AnalyzeImageParams({required this.imagePath, required this.email});

  @override
  List<Object> get props => [imagePath, email];
}
