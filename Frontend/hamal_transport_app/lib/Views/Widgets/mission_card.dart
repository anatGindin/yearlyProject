import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/Widgets/source_destination.dart';

import '../../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import '../mission_screen.dart';
import 'mission_card_base.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MissionCardBase(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MissionScreen(mission: mission)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SourceDestination(mission: mission),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              mission.description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.end,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            '${l10n.time}${_formatDateTime(mission.time)}',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
