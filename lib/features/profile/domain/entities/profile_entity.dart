import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String fullName;
  final String email;
  final String? profilePicture;
  final String gender;
  final DateTime birthDate;
  final double weight;
  final double height;
  final int age;
  final int healthId;
  final int activityId;

  const ProfileEntity({
    required this.fullName,
    required this.email,
    this.profilePicture,
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.age,
    required this.healthId,
    required this.activityId,
  });

  ProfileEntity copyWith({
    String? fullName,
    String? email,
    String? gender,
    DateTime? birthDate,
    double? weight,
    double? height,
    int? healthId,
    int? activityId,
    int? age,
    String? profilePicture,
  }) {
    return ProfileEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      healthId: healthId ?? this.healthId,
      activityId: activityId ?? this.activityId,
      age: age ?? this.age,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  String get healthLabel {
    if (healthId == 2) return "Pasien Diabetes";
    if (healthId == 3) return "Obesitas";
    return "Normal / Sehat";
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    profilePicture,
    gender,
    birthDate,
    weight,
    height,
    age,
    healthId,
    activityId,
  ];
}
