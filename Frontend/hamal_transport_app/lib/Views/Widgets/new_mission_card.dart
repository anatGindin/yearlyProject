import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/new_mission_page.dart';

import '../../l10n/app_localizations.dart';
import 'mission_card_base.dart';

class NewMissionCard extends StatelessWidget {
  const NewMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MissionCardBase(
      color: Theme.of(context).colorScheme.tertiary,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const NewMissionPage())),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.availableMissions,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
