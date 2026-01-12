import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/mission.dart';
import '../../Models/mission_list_type.dart';
import '../../Services/missions_repository.dart';
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
    final repository = context.watch<MissionsRepository>();
    final allMissions = repository.getMissions(MissionListType.allMissions);

    final availableCount = allMissions
        .where((m) => m.status == MissionStatus.available)
        .length;
    final assignedCount = allMissions
        .where((m) => m.status == MissionStatus.assigned)
        .length;
    final pickedUpCount = allMissions
        .where((m) => m.status == MissionStatus.pickedUp)
        .length;
    final deliveredCount = allMissions
        .where((m) => m.status == MissionStatus.delivered)
        .length;
    final cancelledCount = allMissions
        .where((m) => m.status == MissionStatus.cancelled)
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
              if (availableCount > 0)
                _buildLegendItem(Colors.orange, l10n.available, availableCount),
              if (assignedCount > 0)
                _buildLegendItem(Colors.blue, l10n.chosen, assignedCount),
              if (pickedUpCount > 0)
                _buildLegendItem(Colors.green, l10n.pickedUp, pickedUpCount),
              if (deliveredCount > 0)
                _buildLegendItem(Colors.yellow, l10n.delivered, deliveredCount),
              if (cancelledCount > 0)
                _buildLegendItem(Colors.red, l10n.cancelled, cancelledCount),
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
