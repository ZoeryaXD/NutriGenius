import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/history_entity.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Future<Either<Failure, List<HistoryEntity>>> call(String email) async {
    return await repository.getHistory(email);
  }
}