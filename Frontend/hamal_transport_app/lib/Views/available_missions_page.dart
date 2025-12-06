import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'mission_screen.dart';

/// New Mission page now shows the list of available missions (Open Tasks)
class AvailableMissionsPage extends StatelessWidget {
  const AvailableMissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.availableMissions),
      ),
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
