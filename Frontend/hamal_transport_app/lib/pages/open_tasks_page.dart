import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../l10n/app_localizations.dart';
import 'mission_screen.dart';

/// Open Tasks page showing available missions to pick
class OpenTasksPage extends StatelessWidget {
  const OpenTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.openTasks)),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: availableMissions.length,
        separatorBuilder: (_,__) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final m = availableMissions[index];
          return Card(
            child: ListTile(
              title: Text(m.location, textAlign: TextAlign.right),
              subtitle: Text(m.description, textAlign: TextAlign.right),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // when driver chooses a task, move it to active missions and open it
                availableMissions.removeAt(index);
                sampleMissions.insert(0, m..status = 'chosen');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => MissionScreen(mission: m)));
              },
            ),
          );
        },
      ),
    );
  }
}
