import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/MissionsList/list_action_button.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:provider/provider.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Views/MissionsList/route_suggestion_screen.dart';
import 'package:hamal_transport_app/Models/israel_districts.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'mission_list_view.dart';

class MissionsListBody extends StatelessWidget {
  const MissionsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    // We expect the MissionsListViewModel to be provided by the parent
    final viewModel = context.watch<MissionsListViewModel>();
    final userProfile = context.watch<UserProfileViewModel>();
    final isDriver = userProfile.isDriver;
    final isMyMissions = viewModel.type == MissionListType.myMissions;
    final isDeliveredTab = viewModel.type == MissionListType.deliveredMissions;
    final showRouteButton =
        isDriver && isMyMissions && viewModel.missions.length > 1;
    final canArchive =
        !isDriver && isDeliveredTab && viewModel.missions.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: showRouteButton
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RouteSuggestionScreen(missions: viewModel.missions),
                  ),
                );
              },
              icon: const Icon(Icons.route),
              label: Text(AppLocalizations.of(context)!.calculateRoute),
            )
          : canArchive
              ? FloatingActionButton.extended(
                  onPressed: () => viewModel.archiveAllMissions(),
                  icon: const Icon(Icons.archive),
                  label: Text(AppLocalizations.of(context)!.archiveAll),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                )
              : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
            left: 2.0,
            right: 2.0,
          ),
          child: Scrollbar(
            child: RefreshIndicator(
              onRefresh: () => viewModel.refreshMissions(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: viewModel.allowedFilterOptions.isNotEmpty
                                  ? MediaQuery.of(context).size.width * 0.43
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: ListActionButton(
                                icon: Icons.sort,
                                label: viewModel.getSortBy(context),
                                onPressed: () => _showSortOptions(context),
                              ),
                            ),
                            if (viewModel.allowedFilterOptions.isNotEmpty)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ListActionButton(
                                  icon: Icons.filter_alt,
                                  label: viewModel.getFilterBy(context),
                                  onPressed: () => _showFilterOptions(context),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    viewModel.isLoading
                        // TODO: change indicator with skeleton
                        ? const Center(child: CircularProgressIndicator())
                        : MissionListView(missions: viewModel.missions),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final viewModel = context.read<MissionsListViewModel>();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: viewModel.allowedSortOptions
            .map(
              (option) => ListTile(
                title: Text(option.getLabel(context)),
                onTap: () async {
                  if (option == SortBy.distanceToUserClosestFirst ||
                      option == SortBy.distanceToUserFurthestFirst) {
                    await viewModel.sortByGps(option);
                  } else {
                    viewModel.sortBy(option);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final viewModel = context.read<MissionsListViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: viewModel,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, scrollController) => Consumer<MissionsListViewModel>(
            builder: (context, vm, child) {
              return ListView(
                controller: scrollController,
                children: [
                  if (vm.allowedFilterOptions
                      .where((f) => f != FilterBy.byDistrict)
                      .isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context)!.status,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...vm.allowedFilterOptions
                        .where((f) => f != FilterBy.byDistrict)
                        .map(
                          (option) => ListTile(
                            title: Text(option.getLabel(context)),
                            onTap: () {
                              vm.filterBy(option);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                    const Divider(),
                  ],
                  if (vm.allowedFilterOptions.contains(
                    FilterBy.byDistrict,
                  )) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context)!.districts,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...IsraelDistrict.values.map(
                      (district) => CheckboxListTile(
                        title: Text(district.getLabel(context)),
                        value: vm.selectedDistricts.contains(district),
                        onChanged: (bool? value) {
                          if (value != null) {
                            vm.toggleDistrict(district, value);
                          }
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
