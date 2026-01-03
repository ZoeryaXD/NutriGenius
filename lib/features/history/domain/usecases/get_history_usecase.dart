import 'package:nutrigenius/features/history/domain/entities/history_entity.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;
  GetHistoryUseCase(this.repository);

  Future<List<HistoryEntity>> call() async {
    return await repository.getHistory();
  }
}
