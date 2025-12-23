import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import '../mission_screen.dart';
import '../../features/Contact_card/view_model/contact_vm.dart';
import '../../features/Contact_card/view/contact_view.dart';

/// Reusable mission card widget displaying mission information
class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({required this.mission, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(
          '${mission.source.name}\r\n${mission.destination.name}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
          textAlign: TextAlign.right,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              mission.description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 18),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            ContactCard(vm: ContactViewModel(mission.destinationContact)),
            const SizedBox(height: 8),
            Text(
              '${l10n.time}${_formatDateTime(mission.time)}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MissionScreen(mission: mission)),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
