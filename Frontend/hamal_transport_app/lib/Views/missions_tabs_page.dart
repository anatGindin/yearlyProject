import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'active_missions_body.dart';
import 'new_missions_body.dart';

class MissionsTabsPage extends StatelessWidget {
  const MissionsTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.missions),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.assignment_turned_in),
                child: Text(l10n.activeMissions, softWrap: true),
              ),
              Tab(
                icon: const Icon(Icons.add_circle_outline),
                text: l10n.availableMissions,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ActiveMissionsBody(), NewMissionsBody()],
        ),
      ),
    );
  }
}
