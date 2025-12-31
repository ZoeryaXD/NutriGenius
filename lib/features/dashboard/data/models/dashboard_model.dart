class DashboardModel {
  final String displayName;
  final int remainingCalories;
  final double tdee;
  final double progress;
  final int proteinTarget;
  final int carbsTarget;
  final int fatTarget;

  DashboardModel({
    required this.displayName,
    required this.remainingCalories,
    required this.tdee,
    required this.progress,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      // 1. NAMA: Ambil dari 'fullName' (Backend), simpan ke 'displayName' (Flutter)
      displayName: json['fullName'] ?? 'User', 

      // 2. TDEE: Ambil dari 'tdee' atau 'calculated_tdee'
      // Kita pakai (json['x'] ?? 0).toDouble() biar aman kalau datanya null/int
      tdee: _parseDouble(json['tdee']),
      // 3. PROGRESS: (0.0 sampai 1.0)
      progress: _parseDouble(json['progress']),

      // 4. SISA KALORI:
      remainingCalories: _parseInt(json['remaining_calories']),
      // 5. MAKRO NUTRISI:
      proteinTarget: _parseInt(json['protein_target']),
      carbsTarget: _parseInt(json['carbs_target']),
      fatTarget: _parseInt(json['fat_target']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble(); // Kalau sudah angka, langsung convert
    if (value is String) {
      // Kalau string, coba parse. Kalau gagal, return 0.0
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // === HELPER SAKTI: UBAH APAPUN JADI INT ===
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      // Parse dulu jadi double (jaga-jaga kalau stringnya "2000.00"), baru ke int
      return double.tryParse(value)?.toInt() ?? 0;
    }
    return 0;
  }

   Map<String, dynamic> toJson() {
    return {
      'fullName': displayName,
      'tdee': tdee,
      'progress': progress,
      'remaining_calories': remainingCalories,
      'protein_target': proteinTarget,
      'carbs_target': carbsTarget,
      'fat_target': fatTarget,
    };
  }
}
 
