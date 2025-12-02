import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import 'mission_card.dart';

/// Reusable mission list widget that displays a list of missions
class MissionListView extends StatelessWidget {
  final List<Mission> missions;

  const MissionListView({required this.missions, super.key});

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noMissions));
    }
    return ListView.separated(
      itemCount: missions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => MissionCard(mission: missions[index]),
    );
  }
}
