class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final UserRole role;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> userProfileToDictionary() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.name,
    };
  }

  static UserProfile fromDictionary(Map<String, dynamic> dictionary) {
    return UserProfile(
      uid: dictionary['uid'],
      email: dictionary['email'],
      name: dictionary['name'],
      phone: dictionary['phone'],
      role: UserRole.values.firstWhere((e) => e.name == dictionary['role']),
    );
  }
}

enum UserRole { driver, logistics, admin }
