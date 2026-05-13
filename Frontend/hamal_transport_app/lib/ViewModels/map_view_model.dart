import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../Models/mission.dart';
import '../Services/location_service.dart';
import '../Models/user_profile.dart';
import '../Services/authentication_service.dart';

class MapViewModel extends ChangeNotifier {
  // Center of Israel
  static const LatLng initialCenter = LatLng(31.4117, 35.0818);

  LatLng? _userLocation;
  Mission? _selectedMission;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoadingLocation = true;
  final Set<MissionStatus> _visibleStatuses = {
    MissionStatus.available,
    MissionStatus.assigned,
    MissionStatus.pickedUp,
    MissionStatus.delivered,
  };

  UserRole? _userRole;

  bool _isWarehouseSelected = false;

  LatLng? get userLocation => _userLocation;

  Mission? get selectedMission => _selectedMission;

  bool get isWarehouseSelected => _isWarehouseSelected;

  bool get isLoadingLocation => _isLoadingLocation;

  Set<MissionStatus> get visibleStatuses => _visibleStatuses;

  UserRole? get userRole => _userRole;

  MapViewModel({UserRole? role}) : _userRole = role;

  Future<void> checkPermissions() => initLocation();

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    LocationService().stopLocationUpdates();
    super.dispose();
  }

  void selectMission(Mission? mission) {
    _selectedMission = mission;
    if (mission != null) {
      _isWarehouseSelected = false;
    }
    notifyListeners();
  }

  void selectWarehouse(bool selected) {
    _isWarehouseSelected = selected;
    if (selected) {
      _selectedMission = null;
    }
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
    if (userRole == UserRole.driver && status == MissionStatus.delivered) {
      return false;
    }
    return _visibleStatuses.contains(status);
  }

  Future<void> initLocation() async {
    await _positionStreamSubscription?.cancel();

    // Fetch User Role
    try {
      final authService = AuthenticationService();
      if (authService.currentUser != null) {
        final profile = await authService.getUserProfile(
          authService.currentUser!,
        );
        _userRole = profile.role;
        notifyListeners();
      }
    } catch (e) {
      // Handle error or ignore
    }

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

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    LocationService().stopLocationUpdates();
  }
}
