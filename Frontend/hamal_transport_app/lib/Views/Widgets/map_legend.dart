import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/mission.dart';
import '../../ViewModels/missions_coordinator_view_model.dart';
import '../../l10n/app_localizations.dart';

class MapLegend extends StatefulWidget {
  const MapLegend({super.key});

  @override
  State<MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<MapLegend> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final coordinator = context.watch<MissionsCoordinatorViewModel>();

    final availableCount =
        coordinator.availableMissionsVM.availableMissions.length;
    final chosenCount = coordinator.myMissionsVM.myMissions
        .where((m) => m.status == MissionStatus.chosen)
        .length;
    final pickedUpCount = coordinator.myMissionsVM.myMissions
        .where((m) => m.status == MissionStatus.pickedUp)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.legend,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 8),
              _buildLegendItem(Colors.orange, l10n.available, availableCount),
              _buildLegendItem(Colors.blue, l10n.chosen, chosenCount),
              _buildLegendItem(Colors.green, l10n.pickedUp, pickedUpCount),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text('$label ($count)'),
        ],
      ),
    );
  }
}
