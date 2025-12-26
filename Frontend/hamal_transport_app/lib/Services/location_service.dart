import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final StreamController<Position> _positionController =
      StreamController<Position>.broadcast();
  Stream<Position> get positionStream => _positionController.stream;

  StreamSubscription<Position>? _geolocatorSubscription;
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  Future<bool> checkPermissions() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return false;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return false;
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void startLocationUpdates() {
    if (_geolocatorSubscription != null) return;

    // Get initial location
    Geolocator.getCurrentPosition()
        .then((Position position) {
          _currentPosition = position;
          _positionController.add(position);
        })
        .catchError((e) {
          print('Error getting initial location: $e');
        });

    // Listen for updates
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    _geolocatorSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _currentPosition = position;
            _positionController.add(position);
          },
          onError: (e) {
            print('Error in location stream: $e');
          },
        );
  }

  void stopLocationUpdates() {
    _geolocatorSubscription?.cancel();
    _geolocatorSubscription = null;
  }
}
