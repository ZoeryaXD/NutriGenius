class ProfileEntity {
  final String name;
  final String email;
  final String gender;
  final double weight;
  final double height;
  final String birthDate;
  final double bmr;
  final double tdee;

  ProfileEntity({
    required this.name,
    required this.email,
    required this.gender,
    required this.weight,
    required this.height,
    required this.birthDate,
    this.bmr = 0.0,
    this.tdee = 0.0,
  });

  int get age {
    try {
      DateTime birth = DateTime.parse(birthDate);
      DateTime now = DateTime.now();

      if (birth.year > now.year || birth.year < 1900) return 0;

      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }
}
