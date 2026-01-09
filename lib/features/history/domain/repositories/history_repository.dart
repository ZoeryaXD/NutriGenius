import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/history_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<HistoryEntity>>> getHistory(String email);
  Future<Either<Failure, void>> deleteHistory(int id);
}