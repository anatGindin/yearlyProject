import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../Models/mission.dart';

class DriverMapViewModel extends ChangeNotifier {
  // Center of Israel
  static const LatLng initialCenter = LatLng(31.4117, 35.0818);

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
    checkPermissions();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
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

  Future<void> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _isLoadingLocation = false;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isLoadingLocation = false;
      notifyListeners();
      return;
    }

    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    // Get initial location
    Geolocator.getCurrentPosition()
        .then((Position position) {
          _userLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
          notifyListeners();
        })
        .catchError((e) {
          _isLoadingLocation = false;
          notifyListeners();
        });

    // Listen for updates
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _userLocation = LatLng(position.latitude, position.longitude);
            notifyListeners();
          },
        );
  }
}
