class CalculateTDEE {
  // Mengembalikan Map berisi BMR dan TDEE
  Map<String, double> call(String gender, double weight, double height, int age, int activityId) {
    // 1. Hitung BMR (Mifflin-St Jeor)
    double bmr;
    if (gender == 'Laki-laki') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // 2. Tentukan Multiplier
    double multiplier = 1.2;
    switch (activityId) {
      case 1: multiplier = 1.2; break;   // Sedentary
      case 2: multiplier = 1.375; break; // Light Active
      case 3: multiplier = 1.55; break;  // Active
      case 4: multiplier = 1.725; break; // Very Active
    }

    return {'bmr': bmr, 'tdee': bmr * multiplier};
  }
}