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

  factory ActivityLevelModel.fromMap(Map<String, dynamic> map) {
    return ActivityLevelModel(
      id: map['id'] ?? 0,
      levelName: map['level_name'] ?? '',
      multiplier: (map['multiplier'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
    );
  }
}
