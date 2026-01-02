import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.isOnboarded,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['user']['firebaseUid'] ?? '',
      email: json['user']['email'] ?? '',
      isOnboarded: json['isOnboarded'] ?? false,
    );
  }
}
