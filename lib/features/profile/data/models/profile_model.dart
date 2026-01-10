import '../../../../core/network/api_client.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required String fullName,
    required String email,
    String? profilePicture,
    required String gender,
    required DateTime birthDate,
    required double weight,
    required double height,
    required int age,
    required int healthId,
    required int activityId,
  }) : super(
         fullName: fullName,
         email: email,
         profilePicture: profilePicture,
         gender: gender,
         birthDate: birthDate,
         weight: weight,
         height: height,
         age: age,
         healthId: healthId,
         activityId: activityId,
       );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'],
      gender: json['gender'] ?? 'Laki-laki',

      birthDate:
          json['birth_date'] != null
              ? DateTime.parse(json['birth_date'])
              : DateTime.now(),

      weight: _toDouble(json['weight_kg']),
      height: _toDouble(json['height_cm']),

      age: _toInt(json['age']),
      healthId: _toInt(json['health_id'], defaultValue: 1),
      activityId: _toInt(json['activity_id'], defaultValue: 1),
    );
  }

  String get fullImageUrl {
    if (profilePicture == null || profilePicture!.isEmpty) return "";
    final rootUrl = ApiClient.baseUrl.replaceAll('/api', '');
    return "$rootUrl/uploads/profiles/$profilePicture";
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic val, {int defaultValue = 0}) {
    if (val == null) return defaultValue;
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? defaultValue;
    return defaultValue;
  }
}

class ActivityLevelModel {
  final int id;
  final String levelName;
  final double multiplier;
  final String description;

  ActivityLevelModel({
    required this.id,
    required this.levelName,
    required this.multiplier,
    required this.description,
  });

  factory ActivityLevelModel.fromJson(Map<String, dynamic> json) {
    return ActivityLevelModel(
      id: ProfileModel._toInt(json['id']),
      levelName: json['level_name'] ?? '',
      multiplier: ProfileModel._toDouble(json['multiplier']),
      description: json['description'] ?? '',
    );
  }
}

class HealthConditionModel {
  final int id;
  final String conditionName;
  final double sugarLimit;
  final String description;

  HealthConditionModel({
    required this.id,
    required this.conditionName,
    required this.sugarLimit,
    required this.description,
  });

  factory HealthConditionModel.fromJson(Map<String, dynamic> json) {
    return HealthConditionModel(
      id: ProfileModel._toInt(json['id']),
      conditionName: json['condition_name'] ?? '',
      sugarLimit: ProfileModel._toDouble(json['sugar_limit_g']),
      description: json['description'] ?? '',
    );
  }
}
