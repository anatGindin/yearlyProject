import 'package:hamal_transport_app/l10n/app_localizations.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final DriverProfile? driverProfile;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.driverProfile,
  });

  Map<String, dynamic> userProfileToDictionary() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.name,
      'driverProfile': driverProfile?.driverProfileToDictionary(),
    };
  }

  static UserProfile fromDictionary(Map<String, dynamic> dictionary) {
    return UserProfile(
      uid: dictionary['uid'],
      email: dictionary['email'],
      name: dictionary['name'],
      phone: dictionary['phone'],
      role: UserRole.values.firstWhere((e) => e.name == dictionary['role']),
      driverProfile: dictionary['driverProfile'] != null
          ? DriverProfile.fromDictionary(
              Map<String, dynamic>.from(dictionary['driverProfile'] as Map),
            )
          : null,
    );
  }
}

class DriverProfile {
  final CarType carType;

  DriverProfile({required this.carType});

  Map<String, dynamic> driverProfileToDictionary() {
    return {'carType': carType.name};
  }

  static DriverProfile fromDictionary(Map<String, dynamic> dictionary) {
    return DriverProfile(
      carType: CarType.values.firstWhere(
        (e) => e.name == dictionary['carType'],
      ),
    );
  }
}

enum UserRole { driver, logistics, admin }

enum CarType {
  private,
  trailer,
  pickupTruck,
  truck;

  String displayName(AppLocalizations l10n) {
    switch (this) {
      case CarType.private:
        return l10n.privateCar;
      case CarType.trailer:
        return l10n.trailer;
      case CarType.pickupTruck:
        return l10n.pickupTruck;
      case CarType.truck:
        return l10n.truck;
    }
  }
}
