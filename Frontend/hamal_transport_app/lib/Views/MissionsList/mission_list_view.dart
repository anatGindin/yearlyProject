import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import '../SharedWidgets/MissionPage/mission_card.dart';

/// Reusable mission list widget that displays a list of missions
class MissionListView extends StatelessWidget {
  final List<Mission> missions;
  final bool isLoading;
  final MissionStatus status;

  const MissionListView({
    required this.missions,
    required this.isLoading,
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (missions.isEmpty && !isLoading) {
      return Center(child: Text(l10n.noMissions));
    }
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // If loading, force a fixed count (e.g., 3 skeletons), otherwise use real list length
        itemCount: isLoading ? 3 : missions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 30),
        itemBuilder: (context, index) {
          final currentMission = isLoading
              ? Mission.mock(status)
              : missions[index];
          return MissionCard(mission: currentMission);
        },
      ),
    );
  }
}
