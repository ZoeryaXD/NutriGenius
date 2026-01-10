class FirstPageModel {
  final String email;
  final String gender;
  final String birthDate;
  final double weight;
  final double height;
  final int activityId;
  final int healthId;
  final double bmr;
  final double tdee;

  FirstPageModel({
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.activityId,
    required this.healthId,
    required this.bmr,
    required this.tdee,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'gender': gender,
      'birthDate': birthDate,
      'weight': weight,
      'height': height,
      'activityId': activityId,
      'healthId': healthId,
      'bmr': bmr,
      'tdee': tdee,
    };
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
      id: json['id'],
      levelName: json['level_name'],
      multiplier:
          json['multiplier'] is String
              ? double.parse(json['multiplier'])
              : (json['multiplier'] as num).toDouble(),
      description: json['description'],
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
      id: json['id'],
      conditionName: json['condition_name'],
      sugarLimit:
          json['sugar_limit_g'] is String
              ? double.parse(json['sugar_limit_g'])
              : (json['sugar_limit_g'] as num).toDouble(),
      description: json['description'],
    );
  }
}
