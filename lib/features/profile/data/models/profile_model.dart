import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.name,
    required super.email,
    required super.gender,
    required super.weight,
    required super.height,
    required super.birthDate,
    super.bmr,
    super.tdee,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['full_name'] ?? json['name'] ?? 'User Baru',
      email: json['email'] ?? '',
      gender: json['gender'] ?? 'Laki-Laki',
      weight:
          double.tryParse((json['weight_kg'] ?? json['weight']).toString()) ??
          0.0,
      height:
          double.tryParse((json['height_cm'] ?? json['height']).toString()) ??
          0.0,
      birthDate: json['birth_date'] ?? json['birthDate'] ?? '2000-01-01',
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': name,
    'email': email,
    'gender': gender,
    'weight_kg': weight,
    'height_cm': height,
    'birth_date': birthDate,
    'bmr': bmr,
    'tdee': tdee,
  };
}
