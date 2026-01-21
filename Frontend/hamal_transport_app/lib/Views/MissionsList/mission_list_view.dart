import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import '../SharedWidgets/MissionPage/mission_card.dart';

/// Reusable mission list widget that displays a list of missions
class MissionListView extends StatelessWidget {
  final List<Mission> missions;

  const MissionListView({required this.missions, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (missions.isEmpty) {
      return Center(child: Text(l10n.noMissions));
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: missions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 30),
      itemBuilder: (context, index) {
        return MissionCard(mission: missions[index]);
      },
    );
  }
}
