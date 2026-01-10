import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/driver_navigation_bar_wrapper.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import 'package:hamal_transport_app/Views/driver_page.dart';
import 'package:hamal_transport_app/ViewModels/driver_view_model.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:provider/provider.dart';
import '../Models/user_profile.dart';
//

/// Returns the appropriate destination widget based on user role.
/// - Drivers go to MainPage
/// - Logistics users go to DriverPage showing driver from missions
/// - Admin users go to UserProfilePage
Widget getDestinationForRole(UserRole role, BuildContext context) {
  switch (role) {
    case UserRole.driver:
      return const DriverNavigationBarWrapper();
    case UserRole.logistics:
      // Get the first driver UID from the missions repository
      final missionsRepo = context.read<MissionsRepository>();
      final allMissions = missionsRepo.getMissions(MissionListType.allMissions);

      // Find first mission with a driver assigned
      final missionWithDriver = allMissions.firstWhere(
        (mission) => mission.driverUid != null && mission.driverUid!.isNotEmpty,
        orElse: () => allMissions.first,
      );

      final driverUid =
          missionWithDriver.driverUid ?? 'I9ivZ6H8pYWoDkeb2wybbKXgxWE2';

      return ChangeNotifierProvider(
        create: (_) => DriverViewModel(
          driverUid: driverUid,
          authService: context.read<AuthenticationService>(),
          missionsRepository: context.read<MissionsRepository>(),
        ),
        child: const DriverPage(),
      );
    case UserRole.admin:
      return const UserProfilePage();
  }
}
