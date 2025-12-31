import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
    required bool isOnboarded,
  }) : super(uid: uid, email: email, isOnboarded: isOnboarded);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['user']['firebaseUid'] ?? '',
      email: json['user']['email'] ?? '',
      isOnboarded: json['isOnboarded'] ?? false,
    );
  }
}