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
