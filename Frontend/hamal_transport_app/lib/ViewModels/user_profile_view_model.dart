import 'package:flutter/material.dart';
import '../Models/user_profile.dart';
import '../l10n/app_localizations.dart';

class UserProfileViewModel {
  UserProfile userProfile;
  DriverProfileViewModel? driverProfileVM;
  UserProfileViewModel(this.userProfile) {
    if (userProfile.driverProfile != null) {
      driverProfileVM = DriverProfileViewModel(userProfile.driverProfile!);
    }
  }

  String name() {
    return userProfile.name;
  }

  String email() {
    return userProfile.email;
  }

  String phone() {
    return userProfile.phone;
  }

  bool isDriver() {
    return userProfile.role == UserRole.driver;
  }

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

class DriverProfileViewModel {
  DriverProfile driverProfile;

  DriverProfileViewModel(this.driverProfile);

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
