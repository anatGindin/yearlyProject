import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/map_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
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
/// - Logistics and Admin go to UnderConstructionPage
Widget getDestinationForRole(UserRole role) {
  switch (role) {
    case UserRole.driver:
      return ChangeNotifierProvider(
        create: (_) => MapViewModel(),
        child: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            final repository = context.read<MissionsRepository>();
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
                          repository: repository,
                          type: MissionListType.myMissions,
                        ),
                      ),
                      MissionTabConfig(
                        title: l10n.availableMissions,
                        icon: Icons.add_circle_outline,
                        viewModel: MissionsListViewModel(
                          repository: repository,
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
    case UserRole.logistics:
    case UserRole.admin:
      return ChangeNotifierProvider(
        create: (_) => MapViewModel(),
        child: Builder(
          builder: (context) {
            return NavigationBarWrapper(
              allDestinations: [
                //TODO: add more pages for logistics
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
  }
}
