import 'package:nutrigenius/features/history/domain/entities/history_entity.dart';
import '../repositories/history_repository.dart';

class AddFoodUseCase {
  final HistoryRepository repository;

  AddFoodUseCase(this.repository);

  Future<void> call(HistoryEntity food) async {
    return await repository.addFood(food);
  }
}
