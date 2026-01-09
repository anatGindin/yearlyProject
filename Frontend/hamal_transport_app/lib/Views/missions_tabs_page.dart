import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/missions_list_body.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

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
              tabs: tabs
                  .map(
                    (tab) => Tab(
                      icon: Icon(tab.icon),
                      child: Text(tab.title, softWrap: true),
                    ),
                  )
                  .toList(),
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
}
