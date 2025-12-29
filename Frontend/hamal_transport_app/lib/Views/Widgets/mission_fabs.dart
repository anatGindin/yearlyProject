import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/new_missions_body.dart';
import '../../l10n/app_localizations.dart';

/// Reusable FABs widget for phone call and new mission actions
class MissionFABs extends StatelessWidget {
  final VoidCallback onCallDesk;

  const MissionFABs({required this.onCallDesk, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        // Bottom-left phone button
        Positioned(
          left: 8,
          bottom: 12,
          child: FloatingActionButton(
            heroTag: 'phone',
            onPressed: onCallDesk,
            child: const Icon(Icons.phone),
          ),
        ),

        // Bottom-right new mission button
        Positioned(
          right: 8,
          bottom: 12,
          child: FloatingActionButton.extended(
            heroTag: 'new_mission',
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NewMissionsBody())),
            icon: const Icon(Icons.add_box),
            label: Text(
              l10n.availableMissions,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
