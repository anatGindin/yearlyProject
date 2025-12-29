import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/list_action_button.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'mission_screen.dart';

/// New Mission page now shows the list of available missions (Open Tasks)
class NewMissionPage extends StatelessWidget {
  const NewMissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.availableMissions)),
      body: Consumer<AvailableMissionsViewModel>(
        builder: (context, availableMissionsVM, _) {
          return Column(
            children: [
              ListActionButton(
                icon: Icons.sort,
                label:
                    '${l10n.sortBy}: ${availableMissionsVM.getSortBy(context)}',
                onPressed: () => _showSortOptions(context),
              ),
              ListActionButton(
                icon: Icons.filter_alt,
                label:
                    '${l10n.filterBy}: ${availableMissionsVM.getFilterBy(context)}',
                onPressed: () => _showFilterOptions(context),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: availableMissionsVM.availableMissions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final m = availableMissionsVM.availableMissions[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${m.source.name}\r\n${m.destination.name}',
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          m.description,
                          textAlign: TextAlign.right,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MissionScreen(mission: m),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
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
