import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final firebaseUser = await repository.registerFirebase(
          event.email,
          event.password,
        );

        await firebaseUser.sendEmailVerification();

        await repository.syncToBackend(
          firebaseUser.uid,
          event.fullName,
          event.email,
        );

        emit(AuthEmailVerificationRequired());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.loginFirebase(
          event.email,
          event.password,
        );

        if (!user.emailVerified) {
          emit(AuthFailure("Harap verifikasi email Anda terlebih dahulu!"));
          return;
        }

        final isOnboarded = await repository.checkUserStatus(event.email);
        emit(AuthSuccess(isOnboarded));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      try {
        await repository.sendPasswordResetEmail(event.email);
        emit(AuthResetEmailSent());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
