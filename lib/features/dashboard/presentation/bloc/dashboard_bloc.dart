import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/dashboard_model.dart';
import '../../domain/repositories/dashboard_repository.dart';

// EVENTS
abstract class DashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

// STATES
abstract class DashboardState extends Equatable {
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel data;
  DashboardLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// BLOC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;
  final FirebaseAuth firebaseAuth;

  DashboardBloc({required this.repository, required this.firebaseAuth})
    : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final user = firebaseAuth.currentUser;

        if (user != null && user.email != null) {
          // Panggil Repository dengan parameter Email
          // Pastikan di Repository kamu method-nya menerima parameter String email
          final result = await repository.getDashboardData(user.email!);

          emit(DashboardLoaded(result));
        } else {
          emit(DashboardError("User tidak ditemukan / Belum login"));
        }
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
