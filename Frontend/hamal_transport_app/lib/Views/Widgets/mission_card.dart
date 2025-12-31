import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/Widgets/source_destination.dart';
import 'package:intl/intl.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SourceDestination(mission: mission),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Text(
                mission.description,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.today,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat.yMEd(l10n.localeName).format(mission.time),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
