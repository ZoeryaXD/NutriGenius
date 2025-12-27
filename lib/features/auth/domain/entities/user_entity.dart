import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final bool isOnboarded;

  const UserEntity({
    required this.uid, 
    required this.email, 
    required this.isOnboarded
  });

  @override
  List<Object?> get props => [uid, email, isOnboarded];
}