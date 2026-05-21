import 'package:flutter/material.dart';
import '../Models/user_profile.dart';
import '../l10n/app_localizations.dart';
import '../Services/authentication_service.dart';
import '../Services/missions_repository.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfile userProfile;
  DriverProfileExtension? driverProfileExtension;
  final AuthenticationService _authService = AuthenticationService();

  UserProfileViewModel(this.userProfile) {
    updateDriverProfile(userProfile);
  }

  Future<void> logOut() async {
    MissionsRepository().clear();
    await _authService.signOut();
    // notifyListeners();
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

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<void> updateProfile({
    required String name,
    required String phone,
    CarType? carType,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final updatedProfile = UserProfile(
        uid: userProfile.uid,
        email: userProfile.email,
        name: name,
        phone: phone,
        role: userProfile.role,
        driverProfile: carType != null
            ? DriverProfile(carType: carType)
            : userProfile.driverProfile,
      );

      await _authService.updateUserProfile(updatedProfile);

      // Update local state by creating a new VM instance or updating this one
      // For simplicity, let's update this one
      userProfile.name = name;
      userProfile.phone = phone;
      if (carType != null && userProfile.driverProfile != null) {
        userProfile.driverProfile!.carType = carType;
        updateDriverProfile(userProfile);
      }

      notifyListeners();
    } finally {
      _isUpdating = false;
      notifyListeners();
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
