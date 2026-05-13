import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Algorithms/best_route.dart' as algo;
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:hamal_transport_app/Utils/launcher_utils.dart';
import 'package:lottie/lottie.dart';

class RouteSuggestionScreen extends StatefulWidget {
  final List<Mission> missions;

  const RouteSuggestionScreen({super.key, required this.missions});

  @override
  State<RouteSuggestionScreen> createState() => _RouteSuggestionScreenState();
}

class _RouteSuggestionScreenState extends State<RouteSuggestionScreen> {
  bool _isCalculating = true;
  List<_BatchedStep> _batchedSteps = [];

  @override
  void initState() {
    super.initState();
    _calculateRoute();
  }

  Future<void> _calculateRoute() async {
    // Add a small delay for a smooth transition and to allow the progress indicator to show
    await Future.delayed(const Duration(milliseconds: 1000));

    // Calculate the best route
    final steps = algo.BestRoute.calculateBestRoute(widget.missions);

    if (mounted) {
      setState(() {
        _batchedSteps = _batchSteps(steps);
        _isCalculating = false;
      });
    }
  }

  List<_BatchedStep> _batchSteps(List<algo.RouteStep> rawSteps) {
    if (rawSteps.isEmpty) return [];

    final List<_BatchedStep> batched = [];
    _BatchedStep currentBatch = _BatchedStep(rawSteps.first.location, [
      rawSteps.first,
    ]);

    for (int i = 1; i < rawSteps.length; i++) {
      final step = rawSteps[i];
      // Group if distance is less than 1.0 km
      if (currentBatch.location.distanceTo(step.location) < 1.0) {
        currentBatch.steps.add(step);
      } else {
        batched.add(currentBatch);
        currentBatch = _BatchedStep(step.location, [step]);
      }
    }
    batched.add(currentBatch);
    return batched;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routeSuggestion),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        scrolledUnderElevation: 0,
      ),
      body: _isCalculating ? _buildLoading(l10n) : _buildMap(l10n),
    );
  }

  Widget _buildLoading(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset('Resources/Lottie/gps_navigation.json'),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.calculatingRoute,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildMap(AppLocalizations l10n) {
    if (_batchedSteps.isEmpty) {
      return Center(child: Text(l10n.noMissions));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _batchedSteps.length,
      itemBuilder: (context, index) {
        final batch = _batchedSteps[index];
        final isLast = index == _batchedSteps.length - 1;
        return _buildStep(batch, isLast, l10n);
      },
    );
  }

  Widget _buildStep(_BatchedStep batch, bool isLast, AppLocalizations l10n) {
    final hasPickup = batch.steps.any((s) => s.action == algo.Action.pickUp);
    final hasDeliver = batch.steps.any((s) => s.action == algo.Action.deliver);

    String titleText;
    if (hasPickup && hasDeliver) {
      titleText = l10n.headToTasks(batch.location.name);
    } else if (hasPickup) {
      titleText = batch.steps.length > 1
          ? l10n.driveToAndPickup(batch.location.name)
          : l10n.goToAndPickup(
              batch.location.name,
              batch.steps.first.mission.description,
            );
    } else {
      titleText = batch.steps.length > 1
          ? l10n.headToTasks(batch.location.name)
          : l10n.goToAndDeliver(
              batch.location.name,
              batch.steps.first.mission.description,
            );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline graphics
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(100),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              titleText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              LauncherUtils.launchNavigation(
                                batch.location.name,
                              );
                            },
                            icon: const Icon(Icons.navigation),
                            label: Text(l10n.navigateWaze),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (batch.steps.length > 1) ...[
                        const SizedBox(height: 12),
                        ...batch.steps.map((step) {
                          final isPickup = step.action == algo.Action.pickUp;
                          final icon = isPickup
                              ? Icons.arrow_upward
                              : Icons.arrow_downward;
                          final color = isPickup ? Colors.blue : Colors.green;
                          final actionText = isPickup
                              ? l10n.actionPickup
                              : l10n.actionDeliver;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(icon, size: 16, color: color),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "$actionText ${step.mission.description}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BatchedStep {
  final Location location;
  final List<algo.RouteStep> steps;

  _BatchedStep(this.location, this.steps);
}
