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

  String get healthLabel {
    if (healthId == 2) return "Pasien Diabetes";
    if (healthId == 3) return "Obesitas";
    return "Normal / Sehat";
  }

  @override
  List<Object?> get props => [
    email,
    fullName,
    profilePicture,
    weight,
    height,
    activityId,
  ];
}
