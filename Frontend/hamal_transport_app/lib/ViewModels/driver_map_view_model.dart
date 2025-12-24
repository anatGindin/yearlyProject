import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart'; // Keep for Position type if needed, or remove if using only LatLng. But the stream gives Position.
import 'package:latlong2/latlong.dart';
import '../Models/mission.dart';
import '../Services/location_service.dart';

class DriverMapViewModel extends ChangeNotifier {
  // Center of Israel
  static const LatLng initialCenter = LatLng(31.4117, 35.0818);
  static const LatLng hamalWarehouse = LatLng(32.8115, 35.0678);

  LatLng? _userLocation;
  Mission? _selectedMission;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoadingLocation = true;
  final Set<MissionStatus> _visibleStatuses = {
    MissionStatus.available,
    MissionStatus.chosen,
    MissionStatus.pickedUp,
  };

  LatLng? get userLocation => _userLocation;
  Mission? get selectedMission => _selectedMission;
  bool get isLoadingLocation => _isLoadingLocation;
  Set<MissionStatus> get visibleStatuses => _visibleStatuses;

  DriverMapViewModel() {
    _initLocation();
  }

  Future<void> checkPermissions() => _initLocation();

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    LocationService().stopLocationUpdates();
    super.dispose();
  }

  void selectMission(Mission? mission) {
    _selectedMission = mission;
    notifyListeners();
  }

  void toggleStatusVisibility(MissionStatus status) {
    if (_visibleStatuses.contains(status)) {
      _visibleStatuses.remove(status);
    } else {
      _visibleStatuses.add(status);
    }
    notifyListeners();
  }

  bool isStatusVisible(MissionStatus status) {
    return _visibleStatuses.contains(status);
  }

  Future<void> _initLocation() async {
    await _positionStreamSubscription?.cancel();
    final locationService = LocationService();
    final hasPermission = await locationService.checkPermissions();

    if (!hasPermission) {
      _isLoadingLocation = false;
      notifyListeners();
      return;
    }

    locationService.startLocationUpdates();

    // Check for existing location
    if (locationService.currentPosition != null) {
      _updateLocation(locationService.currentPosition!);
    }

    _positionStreamSubscription = locationService.positionStream.listen((
      Position position,
    ) {
      _updateLocation(position);
    });
  }

  void _updateLocation(Position position) {
    _userLocation = LatLng(position.latitude, position.longitude);
    _isLoadingLocation = false;
    notifyListeners();
  }
}
