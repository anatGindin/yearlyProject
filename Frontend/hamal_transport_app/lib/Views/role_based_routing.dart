import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/driver_map_view_model.dart';
import 'package:hamal_transport_app/Views/driver_map_view.dart';
import 'package:hamal_transport_app/Views/driver_navigation_bar_wrapper.dart';
import 'package:hamal_transport_app/Views/missions_tabs_page.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import 'package:provider/provider.dart';
import '../Models/user_profile.dart';
//

/// Returns the appropriate destination widget based on user role.
/// - Drivers go to MainPage
/// - Logistics and Admin go to UnderConstructionPage
Widget getDestinationForRole(UserRole role) {
  switch (role) {
    case UserRole.driver:
      return ChangeNotifierProvider(
        create: (_) => DriverMapViewModel(),
        child: Builder(
          builder: (context) {
            return DriverNavigationBarWrapper(
              allDestinations: [
                const DriverDestination(
                  driverPageType: DriverPageType.missions,
                  page: MissionsTabsPage(),
                ),
                DriverDestination(
                  driverPageType: DriverPageType.mapView,
                  page: const DriverMapView(),
                  onEnter: () =>
                      context.read<DriverMapViewModel>().initLocation(),
                  onExit: () =>
                      context.read<DriverMapViewModel>().stopLocationUpdates(),
                ),
                const DriverDestination(
                  driverPageType: DriverPageType.profile,
                  page: UserProfilePage(),
                ),
              ],
            );
          },
        ),
      );
    case UserRole.logistics:
    case UserRole.admin:
      return const DriverNavigationBarWrapper(
        allDestinations: [
          //TODO: add more pages for logistics
          DriverDestination(
            driverPageType: DriverPageType.profile,
            page: UserProfilePage(),
          ),
        ],
      );
  }
}
