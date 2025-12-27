// Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/auth/domain/repositories/auth_repository.dart';

abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email, password;
  LoginRequested(this.email, this.password);
}
class RegisterRequested extends AuthEvent {
  final String fullName, email, password;
  RegisterRequested(this.fullName, this.email, this.password);
}
class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final bool isOnboarded; // True = ke Dashboard, False = ke FirstPage
  AuthSuccess(this.isOnboarded);
}
class AuthEmailVerificationRequired extends AuthState {} // Muncul dialog cek email
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
class AuthResetEmailSent extends AuthState {} // State untuk lupa password

// BLoC Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository; // Interface Domain

  AuthBloc(this.repository) : super(AuthInitial()) {
    
    // Logic Register
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // 1. Register di Firebase
        final firebaseUser = await repository.registerFirebase(event.email, event.password);
        
        // 2. Kirim Verifikasi Email
        await firebaseUser.sendEmailVerification();
        
        // 3. Simpan data ke MySQL (Panggil API Node.js kita tadi)
        await repository.syncToBackend(firebaseUser.uid, event.fullName, event.email);
        
        emit(AuthEmailVerificationRequired());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Logic Login
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // 1. Login Firebase
        final user = await repository.loginFirebase(event.email, event.password);
        
        // 2. Cek apakah email sudah diverifikasi
        if (!user.emailVerified) {
          emit(AuthFailure("Harap verifikasi email Anda terlebih dahulu!"));
          return;
        }

        // 3. Cek Status User di MySQL (Ke Dashboard atau Onboarding?)
        final isOnboarded = await repository.checkUserStatus(event.email);
        emit(AuthSuccess(isOnboarded));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Logic Lupa Password
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