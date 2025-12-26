import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrigenius/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<SendEmailVerificationEvent>(_onSendEmailVerification);
    on<CheckProfileCompletionEvent>(_onCheckProfileCompletion); // EVENT BARU
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.email, event.password);
      
      final isVerified = await authRepository.isEmailVerified();
      if (!isVerified) {
        emit(EmailNotVerified());
      } else {
        // Check jika profile sudah lengkap
        final hasCompletedProfile = await authRepository.hasUserCompletedProfile();
        if (!hasCompletedProfile) {
          emit(ProfileNotCompleted()); // Ke halaman isi data diri
        } else {
          emit(AuthSuccess()); // Ke dashboard
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Login failed'));
    } catch (e) {
      emit(AuthFailure('An error occurred'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(event.email, event.password);
      emit(RegistrationSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      emit(AuthFailure('An error occurred'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(LoggedOut());
    } catch (e) {
      emit(AuthFailure('Logout failed'));
    }
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final user = authRepository.getCurrentUser();
    if (user != null) {
      final isVerified = await authRepository.isEmailVerified();
      if (!isVerified) {
        emit(EmailNotVerified());
      } else {
        final hasCompletedProfile = await authRepository.hasUserCompletedProfile();
        if (!hasCompletedProfile) {
          emit(ProfileNotCompleted());
        } else {
          emit(AuthSuccess());
        }
      }
    } else {
      emit(LoggedOut());
    }
  }

  Future<void> _onSendEmailVerification(SendEmailVerificationEvent event, Emitter<AuthState> emit) async {
    try {
      await authRepository.sendEmailVerification();
      emit(VerificationEmailSent());
    } catch (e) {
      emit(AuthFailure('Failed to send verification email'));
    }
  }

  // Handler baru untuk check profile completion
  Future<void> _onCheckProfileCompletion(CheckProfileCompletionEvent event, Emitter<AuthState> emit) async {
    final hasCompletedProfile = await authRepository.hasUserCompletedProfile();
    if (!hasCompletedProfile) {
      emit(ProfileNotCompleted());
    } else {
      emit(AuthSuccess());
    }
  }
}