import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

// EVENTS
abstract class DashboardEvent extends Equatable {
  @override List<Object> get props => [];
}
class LoadDashboard extends DashboardEvent {}

// STATES
abstract class DashboardState extends Equatable {
  @override List<Object> get props => [];
}
class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final DashboardEntity data;
  DashboardLoaded(this.data);
  @override List<Object> get props => [data];
}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// BLOC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final data = await repository.loadDashboardData();
        emit(DashboardLoaded(data));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}