import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/history_repository.dart';

class DeleteHistoryUseCase {
  final HistoryRepository repository;

  DeleteHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteHistory(id);
  }
}