import 'package:flutter/material.dart';
import '../Models/user_profile.dart';

class UserProfileViewModel {
  UserProfile userProfile;
  UserProfileViewModel(this.userProfile);

  String name() {
    return userProfile.name;
  }

  String email() {
    return userProfile.email;
  }

  String phone() {
    return userProfile.phone;
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
