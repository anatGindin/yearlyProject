import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/missions_list_body.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import '../../Models/mission_list_type.dart';

class MissionTabConfig {
  final String title;
  final IconData icon;
  final MissionsListViewModel viewModel;

  MissionTabConfig({
    required this.title,
    required this.icon,
    required this.viewModel,
  });
}

class MissionsTabsPage extends StatelessWidget {
  final List<MissionTabConfig> tabs;

  const MissionsTabsPage({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.missions,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,

              tabs: tabs.map((tab) {
                final color = _getStatusColor(tab.viewModel.type);
                return Tab(
                  icon: Icon(tab.icon),
                  child: Container(
                    decoration: color != null
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: color, width: 3.0),
                            ),
                          )
                        : null,
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      tab.title,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: tabs
                    .map(
                      (tab) =>
                          ChangeNotifierProvider<MissionsListViewModel>.value(
                            value: tab.viewModel,
                            child: const MissionsListBody(),
                          ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getStatusColor(MissionListType type) {
    switch (type) {
      case MissionListType.availableMissions:
        return MissionStatus.available.statusColor;
      case MissionListType.assignedMissions:
      case MissionListType.myMissions:
        return MissionStatus.assigned.statusColor;
      case MissionListType.pickedUpMissions:
        return MissionStatus.pickedUp.statusColor;
      case MissionListType.deliveredMissions:
        return MissionStatus.delivered.statusColor;
      case MissionListType.cancelledMissions:
        return MissionStatus.cancelled.statusColor;
      default:
        return null;
    }
  }
}
