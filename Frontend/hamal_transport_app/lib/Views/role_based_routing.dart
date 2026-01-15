import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/Services/navigation_controller.dart';
import 'package:hamal_transport_app/ViewModels/map_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/driver_phone_book_screen.dart';
import 'package:hamal_transport_app/Views/map_view.dart';
import 'package:hamal_transport_app/Views/navigation_bar_wrapper.dart';
import 'package:hamal_transport_app/Views/missions_tabs_page.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../Models/user_profile.dart';
//

/// Returns the appropriate destination widget based on user role.
/// - Drivers go to MainPage
/// - Logistics users go to DriverPage showing driver from missions
/// - Admin users go to UserProfilePage
Widget getDestinationForRole(UserRole role) {
  switch (role) {
    case UserRole.driver:
      return ChangeNotifierProvider(
        create: (_) => MapViewModel(role: UserRole.driver),
        child: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return NavigationBarWrapper(
              allDestinations: [
                NavBarDestination(
                  pageType: NavBarPageType.missions,
                  page: MissionsTabsPage(
                    tabs: [
                      MissionTabConfig(
                        title: l10n.activeMissions,
                        icon: Icons.assignment_turned_in,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.myMissions,
                        ),
                      ),
                      MissionTabConfig(
                        title: l10n.availableMissions,
                        icon: Icons.add_circle_outline,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.availableMissions,
                          allowedFilterOptions: const [FilterBy.noFilter],
                        ),
                      ),
                    ],
                  ),
                ),
                NavBarDestination(
                  pageType: NavBarPageType.mapView,
                  page: const MapView(),
                  onEnter: () => context.read<MapViewModel>().initLocation(),
                  onExit: () =>
                      context.read<MapViewModel>().stopLocationUpdates(),
                ),
                const NavBarDestination(
                  pageType: NavBarPageType.profile,
                  page: UserProfilePage(),
                ),
              ],
            );
          },
        ),
      );
    case UserRole.admin:
    case UserRole.logistics:
      return ChangeNotifierProvider(
        create: (_) => MapViewModel(role: UserRole.logistics),
        child: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return NavigationBarWrapper(
              allDestinations: [
                NavBarDestination(
                  pageType: NavBarPageType.missions,
                  page: MissionsTabsPage(
                    tabs: [
                      MissionTabConfig(
                        title: l10n.availableMissions,
                        icon: Icons.pending,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.availableMissions,
                          allowedFilterOptions: const [],
                        ),
                      ),
                      MissionTabConfig(
                        title: l10n.readyForPickUpMissions,
                        icon: Icons.assignment_turned_in,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.assignedMissions,
                          allowedFilterOptions: const [],
                        ),
                      ),
                      MissionTabConfig(
                        title: l10n.pickedUpMissions,
                        icon: Icons.local_shipping,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.pickedUpMissions,
                          allowedFilterOptions: const [],
                        ),
                      ),
                      MissionTabConfig(
                        title: l10n.cancelledMissions,
                        icon: Icons.cancel,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.cancelledMissions,
                          allowedFilterOptions: const [],
                        ),
                      ),
                      MissionTabConfig(
                        title: l10n.deliveredMissions,
                        icon: Icons.check_circle,
                        viewModel: MissionsListViewModel(
                          type: MissionListType.deliveredMissions,
                          allowedFilterOptions: const [],
                        ),
                      ),
                    ],
                  ),
                ),
                NavBarDestination(
                  pageType: NavBarPageType.mapView,
                  page: const MapView(),
                  // MARK: if we introduce location services on the map page for logisticians, uncomment the onEnter and onExit methods
                  onEnter: () => {},
                  // context.read<MapViewModel>().initLocation(),
                  onExit: () => {},
                  // context.read<MapViewModel>().stopLocationUpdates(),
                ),
                const NavBarDestination(
                  pageType: NavBarPageType.drivers,
                  page: DriverPhoneBookScreen(),
                ),
                const NavBarDestination(
                  pageType: NavBarPageType.profile,
                  page: UserProfilePage(),
                ),
              ],
            );
          },
        ),
      );
  }
}
