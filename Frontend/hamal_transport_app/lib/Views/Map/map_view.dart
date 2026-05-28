import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../Models/mission.dart';
import '../../Models/mission_list_type.dart';
import '../../Services/missions_repository.dart';
import '../../Constants/official_info.dart';
import '../../ViewModels/map_view_model.dart';
import '../../Models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import 'map_legend.dart';
import 'mission_map_card.dart';
import 'selected_marker.dart';
import 'warehouse_map_card.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapViewContent();
  }
}

class MapViewContent extends StatefulWidget {
  const MapViewContent({super.key});

  @override
  State<MapViewContent> createState() => _MapViewContentState();
}

class _MapViewContentState extends State<MapViewContent> {
  // Center of Israel
  static const LatLng _initialCenter = MapViewModel.initialCenter;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                  if (viewModel.isWarehouseSelected) {
                    viewModel.selectWarehouse(false);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.technion.transport',
                  retinaMode: RetinaMode.isHighDensity(context),
                ),
                MarkerLayer(
                  markers: [
                    ..._buildMissionMarkers(context),
                    if (viewModel.userLocation != null &&
                        viewModel.userRole == UserRole.driver)
                      _buildUserMarker(viewModel.userLocation!),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: 20,
              child: MapLegend(viewModel: viewModel),
            ),
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
            if (viewModel.selectedMission == null &&
                !viewModel.isWarehouseSelected &&
                viewModel.userRole == UserRole.driver)
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
                  ],
                ),
              ),
            if (viewModel.selectedMission != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: MissionMapCard(
                  mission: viewModel.selectedMission!,
                  viewModel: viewModel,
                ),
              ),
            if (viewModel.isWarehouseSelected)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: WarehouseMapCard(viewModel: viewModel),
              ),
          ],
        ),
      ),
    );
  }

  void _showLayersDialog(BuildContext context, MapViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<MapViewModel>(
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
                      MissionStatus.available.statusColor,
                      l10n.available,
                    ),
                    _buildLayerCheckbox(
                      context,
                      viewModel,
                      MissionStatus.assigned,
                      MissionStatus.assigned.statusColor,
                      l10n.chosen,
                    ),
                    _buildLayerCheckbox(
                      context,
                      viewModel,
                      MissionStatus.pickedUp,
                      MissionStatus.pickedUp.statusColor,
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
    MapViewModel viewModel,
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
    final repository = context.watch<MissionsRepository>();
    final viewModel = context.read<MapViewModel>();
    final markers = <Marker>[];

    // Hamal Warehouse Marker
    markers.add(
      Marker(
        point: hamalWarehouse,
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => viewModel.selectWarehouse(true),
          child: Center(
            child: AnimatedScale(
              scale: viewModel.isWarehouseSelected ? 1.5 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white.withValues(alpha: 0.85),
                    size: 40,
                  ),
                  const Positioned(
                    top: 5,
                    child: Icon(
                      Icons.warehouse,
                      color: Color.fromARGB(255, 113, 68, 0),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    MissionListType missionListType = viewModel.userRole == UserRole.driver
        ? MissionListType.myMissions
        : MissionListType.allMissions;
    for (final mission in repository.getMissions(missionListType)) {
      if (!viewModel.isStatusVisible(mission.status)) continue;
      markers.add(
        _createMissionMarker(mission, mission.status.statusColor, viewModel),
      );
    }

    if (viewModel.userRole == UserRole.driver) {
      for (final mission in repository.getMissions(
        MissionListType.availableMissions,
      )) {
        if (!viewModel.isStatusVisible(mission.status)) continue;
        markers.add(
          _createMissionMarker(mission, mission.status.statusColor, viewModel),
        );
      }
    }

    if (viewModel.selectedMission != null) {
      markers.add(
        Marker(
          key: ValueKey('selected_${viewModel.selectedMission!.id}'),
          point: LatLng(
            viewModel.selectedMission!.destination.latitude,
            viewModel.selectedMission!.destination.longitude,
          ),
          width: 70,
          height: 70,
          child: const SelectedMarker(),
        ),
      );
    }

    return markers;
  }

  Marker _createMissionMarker(
    Mission mission,
    Color color,
    MapViewModel viewModel,
  ) {
    final point = LatLng(
      mission.destination.latitude,
      mission.destination.longitude,
    );

    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {
          viewModel.selectMission(mission);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Black Border (Simulated by larger black icon behind)
            Icon(
              Icons.location_on,
              color: Colors.white.withValues(alpha: 0.75),
              size: 40,
            ),
            // Colored Inner Icon
            Icon(Icons.location_on, color: color, size: 30),
          ],
        ),
      ),
    );
  }
}
