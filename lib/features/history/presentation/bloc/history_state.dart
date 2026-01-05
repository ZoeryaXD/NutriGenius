import 'package:nutrigenius/features/history/domain/entities/history_entity.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryEntity> histories;
  final List<double> chartData;

  HistoryLoaded(this.histories, this.chartData);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
