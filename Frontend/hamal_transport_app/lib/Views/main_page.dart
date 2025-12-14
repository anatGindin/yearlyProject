import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/list_action_button.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'Widgets/mission_app_bar.dart';
import 'Widgets/mission_list_view.dart';
import 'Widgets/mission_fabs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/official_info.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final myMissionsVM = context.watch<MyMissionsViewModel>();
    return Scaffold(
      appBar: const MissionAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    l10n.activeMissions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  ListActionButton(
                    icon: Icons.sort,
                    label: '${l10n.sortBy}: ${myMissionsVM.getSortBy(context)}',
                    onPressed: () => _showSortOptions(context),
                  ),
                  ListActionButton(
                    icon: Icons.filter_alt,
                    label:
                        '${l10n.filterBy}: ${myMissionsVM.getFilterBy(context)}',
                    onPressed: () => _showFilterOptions(context),
                  ),
                  // Expanded mission list
                  Expanded(
                    child: Consumer<MyMissionsViewModel>(
                      builder: (context, myMissionsVM, _) {
                        return MissionListView(
                          missions: myMissionsVM.myMissions,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 72,
                  ), // spacing to keep list above buttons
                ],
              ),
              MissionFABs(onCallDesk: () => _callHamalDesk(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _callHamalDesk(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.callDesk),
        content: Text(l10n.callDeskMessage),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            child: const Icon(Icons.phone),
            onPressed: () async {
              Navigator.of(context).pop();
              final uri = Uri(scheme: 'tel', path: hamalPhone);
              await launchUrl(uri);
            },
          ),

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final myMissionsVM = context.read<MyMissionsViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l10n.newestToOldest),
            onTap: () {
              myMissionsVM.sortBy(SortBy.timeNewestFirst);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.oldestToNewest),
            onTap: () {
              myMissionsVM.sortBy(SortBy.timeOldestFirst);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.closestToFurthest),
            onTap: () {
              myMissionsVM.sortBy(SortBy.distanceClosestFirst);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.furthestToClosest),
            onTap: () {
              myMissionsVM.sortBy(SortBy.distanceFurthestFirst);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final myMissionsVM = context.read<MyMissionsViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l10n.noFilter),
            onTap: () {
              myMissionsVM.filterBy(FilterBy.noFilter);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.chosenFilter),
            onTap: () {
              myMissionsVM.filterBy(FilterBy.chosenOnly);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.pickedUpFilter),
            onTap: () {
              myMissionsVM.filterBy(FilterBy.pickedUpOnly);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
