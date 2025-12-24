import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart'; // This import is no longer needed in the view, as location logic is in ViewModel.
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../Models/mission.dart';
import '../ViewModels/available_missions_view_model.dart';
import '../ViewModels/driver_map_view_model.dart'; // New import for the ViewModel
import '../ViewModels/my_missions_view_model.dart';
import '../l10n/app_localizations.dart';
import 'mission_screen.dart';

class DriverMapView extends StatelessWidget {
  const DriverMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DriverMapViewModel(),
      child: const DriverMapViewContent(),
    );
  }
}

class DriverMapViewContent extends StatefulWidget {
  const DriverMapViewContent({super.key});

  @override
  State<DriverMapViewContent> createState() => _DriverMapViewContentState();
}

class _DriverMapViewContentState extends State<DriverMapViewContent> {
  // Center of Israel
  static const LatLng _initialCenter = DriverMapViewModel.initialCenter;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // ViewModel initializes itself in constructor
  }

  @override
  void dispose() {
    _mapController.dispose();
    // The ViewModel's dispose method will handle cancelling the position stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DriverMapViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.mapView)),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 8.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onTap: (_, _) {
                if (viewModel.selectedMission != null) {
                  viewModel.selectMission(null);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.hamal.transport',
                retinaMode: RetinaMode.isHighDensity(context),
              ),
              MarkerLayer(
                markers: [
                  ..._buildMissionMarkers(context),
                  if (viewModel.userLocation != null)
                    _buildUserMarker(viewModel.userLocation!),
                ],
              ),
            ],
          ),
          const Positioned(top: 20, left: 20, child: _MapLegend()),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'layers',
              mini: true,
              shape: const CircleBorder(),
              onPressed: () => _showLayersDialog(context, viewModel),
              tooltip: AppLocalizations.of(context)!.layers,
              child: const Icon(Icons.layers),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'center',
                  onPressed: () {
                    viewModel.checkPermissions().then((_) {
                      if (viewModel.userLocation != null) {
                        _mapController.move(viewModel.userLocation!, 10.0);
                      }
                    });
                  },
                  tooltip: AppLocalizations.of(context)!.center,
                  child: const Icon(Icons.my_location),
                ),
                // Add spacer if popup is visible to avoid overlap
                if (viewModel.selectedMission != null)
                  const SizedBox(height: 180),
              ],
            ),
          ),
          if (viewModel.selectedMission != null)
            _buildMissionPopup(context, viewModel.selectedMission!, viewModel),
        ],
      ),
    );
  }

  void _showLayersDialog(BuildContext context, DriverMapViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<DriverMapViewModel>(
            builder: (context, viewModel, child) {
              return AlertDialog(
                title: Text(l10n.layers),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLayerCheckbox(
                      context,
                      viewModel,
                      MissionStatus.available,
                      Colors.orange,
                      l10n.available,
                    ),
                    _buildLayerCheckbox(
                      context,
                      viewModel,
                      MissionStatus.chosen,
                      Colors.blue,
                      l10n.chosen,
                    ),
                    _buildLayerCheckbox(
                      context,
                      viewModel,
                      MissionStatus.pickedUp,
                      Colors.green,
                      l10n.pickedUp,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.close),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLayerCheckbox(
    BuildContext context,
    DriverMapViewModel viewModel,
    MissionStatus status,
    Color color,
    String label,
  ) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(Icons.circle, color: color, size: 12),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      value: viewModel.isStatusVisible(status),
      onChanged: (value) => viewModel.toggleStatusVisibility(status),
    );
  }

  Marker _buildUserMarker(LatLng userLocation) {
    return Marker(
      point: userLocation,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.my_location, color: Colors.blue, size: 24),
      ),
    );
  }

  List<Marker> _buildMissionMarkers(BuildContext context) {
    final availableVM = context.watch<AvailableMissionsViewModel>();
    final myMissionsVM = context.watch<MyMissionsViewModel>();
    final viewModel = context
        .read<DriverMapViewModel>(); // Use read for actions
    final markers = <Marker>[];

    // Available Missions (Orange)
    if (viewModel.isStatusVisible(MissionStatus.available)) {
      for (final mission in availableVM.availableMissions) {
        markers.add(_createMissionMarker(mission, Colors.orange, viewModel));
      }
    }

    // My Missions
    for (final mission in myMissionsVM.myMissions) {
      if (!viewModel.isStatusVisible(mission.status)) continue;

      Color color;
      switch (mission.status) {
        case MissionStatus.chosen:
          color = Colors.blue;
        case MissionStatus.pickedUp:
          color = Colors.green;
        case MissionStatus.delivered:
        case MissionStatus.cancelled:
        case MissionStatus.available:
          color = Colors.orange;
      }
      markers.add(_createMissionMarker(mission, color, viewModel));
    }

    return markers;
  }

  Marker _createMissionMarker(
    Mission mission,
    Color color,
    DriverMapViewModel viewModel,
  ) {
    final point = LatLng(
      mission.destination.latitude,
      mission.destination.longitude,
    );

    return Marker(
      point: point,
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () {
          viewModel.selectMission(mission);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Black Border (Simulated by larger black icon behind)
            const Icon(Icons.location_on, color: Colors.black, size: 60),
            // Colored Inner Icon
            Icon(Icons.location_on, color: color, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionPopup(
    BuildContext context,
    Mission mission,
    DriverMapViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MissionScreen(mission: mission),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mission.description,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        viewModel.selectMission(null);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        mission.destination.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      mission.time.toString().substring(0, 16),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.status}: ${mission.status.displayName(context)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapLegend extends StatefulWidget {
  const _MapLegend();

  @override
  State<_MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<_MapLegend> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final availableVM = context.watch<AvailableMissionsViewModel>();
    final myMissionsVM = context.watch<MyMissionsViewModel>();

    final availableCount = availableVM.availableMissions.length;
    final chosenCount = myMissionsVM.myMissions
        .where((m) => m.status == MissionStatus.chosen)
        .length;
    final pickedUpCount = myMissionsVM.myMissions
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
