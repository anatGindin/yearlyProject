import 'package:flutter/material.dart';
import '../Models/user_profile.dart';
import 'main_page.dart';
import 'under_construction_page.dart';

/// Returns the appropriate destination widget based on user role.
/// - Drivers go to MainPage
/// - Logistics and Admin go to UnderConstructionPage
Widget getDestinationForRole(UserRole role) {
  switch (role) {
    case UserRole.driver:
      return const MainPage();
    case UserRole.logistics:
    case UserRole.admin:
      return const UnderConstructionPage();
  }
}
