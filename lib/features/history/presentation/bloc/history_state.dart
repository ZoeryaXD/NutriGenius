import 'package:equatable/equatable.dart';
import '../../domain/entities/history_entity.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryEntity> histories;
  final List<double> weeklyCalories;
  final double totalCaloriesThisWeek;
  final double dailyAverage;

  const HistoryLoaded({
    required this.histories,
    required this.weeklyCalories,
    required this.totalCaloriesThisWeek,
    required this.dailyAverage,
  });

  @override
  List<Object> get props => [
    histories,
    weeklyCalories,
    totalCaloriesThisWeek,
    dailyAverage,
  ];
}

class HistoryFailure extends HistoryState {
  final String message;
  const HistoryFailure(this.message);

  @override
  List<Object> get props => [message];
}
