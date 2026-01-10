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
              ? DateTime.parse(json['birth_date']).toLocal()
              : DateTime.now(),

      weight: _toDouble(json['weight_kg']),
      height: _toDouble(json['height_cm']),

      age: json['age'] ?? 0,
      healthId: json['health_id'] ?? 1,
      activityId: json['activity_id'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'gender': gender,
      'birth_date': birthDate.toIso8601String().split('T')[0],
      'weight_kg': weight,
      'height_cm': height,
      'health_id': healthId,
      'activity_id': activityId,
    };
  }

  String get fullImageUrl {
    if (profilePicture == null) return "";
    final rootUrl = ApiClient.baseUrl.replaceAll('/api', '');
    return "$rootUrl/uploads/profiles/$profilePicture";
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) {
      return double.tryParse(val) ?? 0.0;
    }
    return 0.0;
  }
}
