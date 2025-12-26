part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class RegistrationSuccess extends AuthState {}

class LoggedOut extends AuthState {}

class EmailNotVerified extends AuthState {}

class VerificationEmailSent extends AuthState {}

class ProfileNotCompleted extends AuthState {} // STATE BARU

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}