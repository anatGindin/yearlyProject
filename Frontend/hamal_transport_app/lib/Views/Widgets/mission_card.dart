import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../Theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/mission.dart';
import '../mission_screen.dart';
import '../../features/Contact_card/view_model/contact_vm.dart';
import '../../features/Contact_card/view/contact_view.dart';

/// Reusable mission card widget displaying mission information
class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({required this.mission, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MissionScreen(mission: mission)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // full width
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SourceDestinationWidget(mission: mission),
              const SizedBox(height: 8),
              Text(
                mission.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 8),
              // ContactCard(vm: ContactViewModel(mission.destinationContact)),
              const SizedBox(height: 8),
              Text(
                '${l10n.time}${_formatDateTime(mission.time)}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _SourceDestinationWidget extends StatelessWidget {
  final Mission mission;
  const _SourceDestinationWidget({required this.mission, super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.location_on),
              Container(
                height: 45,
                width: 2,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const Icon(Icons.location_on),
            ],
          ),
          const SizedBox(width: 8),
          // Right: text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mission.source.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
