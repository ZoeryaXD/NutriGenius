import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/entities/history_entity.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistory;
  final DeleteHistoryUseCase deleteHistory;

  HistoryBloc({required this.getHistory, required this.deleteHistory})
    : super(HistoryInitial()) {
    on<LoadHistoryEvent>((event, emit) async {
      emit(HistoryLoading());
      final result = await getHistory(event.email);
      result.fold((failure) => emit(HistoryFailure(failure.message)), (data) {
        final stats = _calculateWeeklyStats(data);
        emit(
          HistoryLoaded(
            histories: data,
            weeklyCalories: stats['weeklyChart'] as List<double>,
            totalCaloriesThisWeek: stats['total'] as double,
            dailyAverage: stats['average'] as double,
          ),
        );
      });
    });

    on<DeleteHistoryEvent>((event, emit) async {
      final result = await deleteHistory(event.id);
      result.fold(
        (failure) => emit(HistoryFailure(failure.message)),
        (_) => add(LoadHistoryEvent(event.email)),
      );
    });
  }

  Map<String, dynamic> _calculateWeeklyStats(List<HistoryEntity> data) {
    List<double> weeklyChart = [0, 0, 0, 0, 0, 0, 0];
    double total = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: now.weekday - 1));

    for (var item in data) {
      final itemDate = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );
      int diff = itemDate.difference(monday).inDays;
      if (diff >= 0 && diff <= 6) {
        weeklyChart[diff] += item.calories;
        total += item.calories;
      }
    }
    double average = total > 0 ? total / now.weekday : 0;
    return {'weeklyChart': weeklyChart, 'total': total, 'average': average};
  }
}
