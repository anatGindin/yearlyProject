import 'package:flutter/material.dart';
import '../../Models/mission.dart';

class SourceDestination extends StatelessWidget {
  final Mission mission;

  const SourceDestination({super.key, required this.mission});

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
                color: Theme.of(context).colorScheme.primary,
              ),
              Container(
                height: 45,
                width: 2,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
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
