import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/driver_navigation_bar_wrapper.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import '../Models/user_profile.dart';
//

/// Returns the appropriate destination widget based on user role.
/// - Drivers go to MainPage
/// - Logistics and Admin go to UnderConstructionPage
Widget getDestinationForRole(UserRole role) {
  switch (role) {
    case UserRole.driver:
      return const DriverNavigationBarWrapper();
    case UserRole.logistics:
    case UserRole.admin:
      return const UserProfilePage();
  }
}
