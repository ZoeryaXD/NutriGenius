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

  factory HealthConditionModel.fromMap(Map<String, dynamic> map) {
    return HealthConditionModel(
      id: map['id'] ?? 0,
      conditionName: map['condition_name'] ?? '',
      sugarLimit: (map['sugar_limit'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
    );
  }
}
