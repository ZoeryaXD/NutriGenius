import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required String displayName,
    required double tdee,
    required double caloriesConsumed,
    required double proteinTarget,
    required double proteinConsumed,
    required double carbsTarget,
    required double carbsConsumed,
    required double fatTarget,
    required double fatConsumed,
  }) : super(
         displayName: displayName,
         tdee: tdee,
         caloriesConsumed: caloriesConsumed,
         proteinTarget: proteinTarget,
         proteinConsumed: proteinConsumed,
         carbsTarget: carbsTarget,
         carbsConsumed: carbsConsumed,
         fatTarget: fatTarget,
         fatConsumed: fatConsumed,
       );

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      displayName: json['full_name'] ?? '',

      tdee: _toDouble(json['tdee']),
      caloriesConsumed: _toDouble(json['calories_consumed']),

      proteinTarget: _toDouble(json['protein_target']),
      proteinConsumed: _toDouble(json['protein_consumed']),

      carbsTarget: _toDouble(json['carbs_target']),
      carbsConsumed: _toDouble(json['carbs_consumed']),

      fatTarget: _toDouble(json['fat_target']),
      fatConsumed: _toDouble(json['fat_consumed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': displayName,
      'tdee': tdee,
      'calories_consumed': caloriesConsumed,
      'protein_target': proteinTarget,
      'protein_consumed': proteinConsumed,
      'carbs_target': carbsTarget,
      'carbs_consumed': carbsConsumed,
      'fat_target': fatTarget,
      'fat_consumed': fatConsumed,
    };
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
