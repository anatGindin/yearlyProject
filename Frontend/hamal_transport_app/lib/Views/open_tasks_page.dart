import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_coordinator_view_model.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'mission_screen.dart';

/// Open Tasks page showing available missions to pick
class OpenTasksPage extends StatelessWidget {
  const OpenTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the myMissionsViewModel and coordinator
    final missionsCoordinator = context.read<MissionsCoordinatorViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.openTasks)),
      body: Consumer<AvailableMissionsViewModel>(
        builder: (context, availableMissionsVM, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: availableMissionsVM.availableMissions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = availableMissionsVM.availableMissions[index];
              return Card(
                child: ListTile(
                  title: Text(m.location, textAlign: TextAlign.right),
                  subtitle: Text(m.description, textAlign: TextAlign.right),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // when driver chooses a task, move it to active missions and open it
                    missionsCoordinator.takeMission(m);
                    m.status = 'chosen';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MissionScreen(mission: m),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
