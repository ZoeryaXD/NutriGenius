import '../repositories/history_repository.dart';

class DeleteHistoryUseCase {
  final HistoryRepository repository;

  DeleteHistoryUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteHistory(id);
  }
}
