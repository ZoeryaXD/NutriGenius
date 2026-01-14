import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/history_repository.dart';

class DeleteHistoryUseCase {
  final HistoryRepository repository;
  DeleteHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call(List<int> ids) async {
    return await repository.deleteHistory(ids);
  }
}
