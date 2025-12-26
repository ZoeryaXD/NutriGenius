class UserModel {
  final String uid;
  final String email;
  final String? name;
  final DateTime? createdAt;
  final bool hasCompletedProfile;
  
  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.createdAt,
    this.hasCompletedProfile = false,
  });
  
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      createdAt: map['createdAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
        : null,
      hasCompletedProfile: map['hasCompletedProfile'] ?? false,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'hasCompletedProfile': hasCompletedProfile,
    };
  }
}