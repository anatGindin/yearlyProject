import 'package:flutter/material.dart';
import '../Models/user_profile.dart';
import '../l10n/app_localizations.dart';
import '../Services/authentication_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserProfile userProfile;
  DriverProfileExtension? driverProfileExtension;
  final AuthenticationService _authService = AuthenticationService();

  UserProfileViewModel(this.userProfile) {
    updateDriverProfile(userProfile);
  }

  Future<void> logOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  void updateDriverProfile(UserProfile userProfile) {
    if (userProfile.driverProfile != null) {
      driverProfileExtension = DriverProfileExtension(
        userProfile.driverProfile!,
      );
    }
  }

  String get name => userProfile.name;

  String get email => userProfile.email;

  String get phone => userProfile.phone;

  bool get isDriver => userProfile.role == UserRole.driver;

  String role(AppLocalizations l10n) {
    switch (userProfile.role) {
      case UserRole.driver:
        return l10n.driver;
      case UserRole.logistics:
        return l10n.logistics;
      case UserRole.admin:
        return l10n.admin;
    }
  }

  IconData roleIcon() {
    switch (userProfile.role) {
      case UserRole.driver:
        return Icons.directions_car;
      case UserRole.logistics:
        return Icons.support_agent;
      case UserRole.admin:
        return Icons.supervisor_account;
    }
  }
}

class DriverProfileExtension {
  DriverProfile driverProfile;

  DriverProfileExtension(this.driverProfile);

  IconData carTypeIcon() {
    switch (driverProfile.carType) {
      case CarType.private:
        return Icons.directions_car;
      case CarType.trailer:
        return Icons.rv_hookup;
      case CarType.pickupTruck:
        return Icons.local_shipping;
      case CarType.truck:
        return Icons.local_shipping;
    }
  }

  String carType(AppLocalizations l10n) {
    switch (driverProfile.carType) {
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
