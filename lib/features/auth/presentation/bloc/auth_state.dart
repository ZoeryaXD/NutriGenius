import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isOnboarded;

  AuthSuccess(this.isOnboarded);

  @override
  List<Object> get props => [isOnboarded];
}

class AuthEmailVerificationRequired extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AuthResetEmailSent extends AuthState {}