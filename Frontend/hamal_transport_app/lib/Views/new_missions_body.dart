import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/list_action_button.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'Widgets/mission_list_view.dart';

/// New Mission page now shows the list of available missions (Open Tasks)
class NewMissionsBody extends StatelessWidget {
  const NewMissionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AvailableMissionsViewModel>(
        builder: (context, availableMissionsVM, _) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 2.0,
                  bottom: 2.0,
                  left: 2.0,
                  right: 2.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ListActionButton(
                                  icon: Icons.sort,
                                  label: availableMissionsVM.getSortBy(context),
                                  onPressed: () => _showSortOptions(context),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ListActionButton(
                                  icon: Icons.filter_alt,
                                  label: availableMissionsVM.getFilterBy(
                                    context,
                                  ),
                                  onPressed: () => _showFilterOptions(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MissionListView(
                        missions: availableMissionsVM.availableMissions,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final availableMissionsVM = context.read<AvailableMissionsViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l10n.newestToOldest),
            onTap: () {
              availableMissionsVM.sortBy(SortBy.timeNewestFirst);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.oldestToNewest),
            onTap: () {
              availableMissionsVM.sortBy(SortBy.timeOldestFirst);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.closestToFurthest),
            onTap: () {
              availableMissionsVM.sortBy(SortBy.distanceClosestFirst);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.furthestToClosest),
            onTap: () {
              availableMissionsVM.sortBy(SortBy.distanceFurthestFirst);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final availableMissionsVM = context.read<AvailableMissionsViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l10n.noFilter),
            onTap: () {
              availableMissionsVM.filterBy(FilterBy.noFilter);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
