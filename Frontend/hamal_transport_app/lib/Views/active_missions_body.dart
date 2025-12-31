import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/list_action_button.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'Widgets/mission_list_view.dart';

class ActiveMissionsBody extends StatelessWidget {
  const ActiveMissionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final myMissionsVM = context.watch<MyMissionsViewModel>();
    return Scaffold(
      body: SafeArea(
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
                            label: myMissionsVM.getSortBy(context),
                            onPressed: () => _showSortOptions(context),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: ListActionButton(
                            icon: Icons.filter_alt,
                            label: myMissionsVM.getFilterBy(context),
                            onPressed: () => _showFilterOptions(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                MissionListView(missions: myMissionsVM.myMissions),
                // const SizedBox(height: 30),
                // const NewMissionCard(),
                // spacing to keep list above buttons
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],
            ),
          ),
        ),
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
          ListTile(
            title: Text(l10n.distanceFromYouClosest),
            onTap: () async {
              await myMissionsVM.sortByGps(SortBy.distanceToUserClosestFirst);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.distanceFromYouFurthest),
            onTap: () async {
              await myMissionsVM.sortByGps(SortBy.distanceToUserFurthestFirst);
              if (context.mounted) Navigator.pop(context);
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
