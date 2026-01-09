import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class SaveScanUseCase implements UseCase<void, SaveScanParams> {
  final ScanRepository repository;

  SaveScanUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveScanParams params) async {
    return await repository.saveScan(params.result, params.email);
  }
}

class SaveScanParams extends Equatable {
  final ScanResult result;
  final String email;

  const SaveScanParams({required this.result, required this.email});

  @override
  List<Object> get props => [result, email];
}