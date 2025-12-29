import 'package:flutter/material.dart';

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
          _SourceDestinationWidget(mission: mission),
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

class _SourceDestinationWidget extends StatelessWidget {
  final Mission mission;

  const _SourceDestinationWidget({required this.mission});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.location_on,
                size: 26,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Container(
                height: 45,
                width: 2,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Right: text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mission.source.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  mission.destination.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
