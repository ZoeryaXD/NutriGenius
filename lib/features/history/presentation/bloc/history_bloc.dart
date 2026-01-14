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
      final result = await deleteHistory(event.ids);
      result.fold((failure) => emit(HistoryFailure(failure.message)), (_) {
        add(LoadHistoryEvent(event.email));
      });
    });
  }

  Map<String, dynamic> _calculateWeeklyStats(List<HistoryEntity> data) {
    List<double> weeklyChart = [0, 0, 0, 0, 0, 0, 0];
    double total = 0;

    final now = DateTime.now();
    final MondayThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfCurrentWeek = DateTime(
      MondayThisWeek.year,
      MondayThisWeek.month,
      MondayThisWeek.day,
    );

    for (var item in data) {
      final itemDate = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );

      int dayIndex = item.createdAt.weekday - 1;

      if (itemDate.isAfter(
        startOfCurrentWeek.subtract(const Duration(seconds: 1)),
      )) {
        weeklyChart[dayIndex] += item.calories;
        total += item.calories;
      }
    }

    double average = total > 0 ? total / 7 : 0;
    return {'weeklyChart': weeklyChart, 'total': total, 'average': average};
  }
}
